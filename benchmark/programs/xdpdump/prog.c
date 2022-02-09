#include <assert.h>
#include <libgen.h>
#include <perf-sys.h>
#include <poll.h>
#include <signal.h>
#include <stdlib.h>
#include <string.h>
#include <arpa/inet.h>
#include <bpf/bpf.h>
#include <bpf/libbpf.h>
#include <linux/if_ether.h>
#include <linux/if_link.h>
#include <net/if.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <sys/sysinfo.h>
#include "prog.h"

#define NS_IN_SEC 1000000000
#define PAGE_CNT 8

static __u32 XDPFLAGS;
static int IFINDEX;
bool DUMPPAYLOAD;

/**
 * @brief Unload the eBPF program from the XDP and
 */
static void _unloadProg()
{
	bpf_set_link_xdp_fd(IFINDEX, -1, XDPFLAGS);
	printf("Unloading the eBPF program...");
	exit(0);
}

/**
 * @brief Print the basic information about the packet received
 * @param meta Packet metadata
 * @param timestamp Packet timestamp 
 */
void metaPrint(struct pkt_meta meta, __u64 timestamp)
{
	char src_str[INET6_ADDRSTRLEN];
	char dst_str[INET6_ADDRSTRLEN];
	char l3_str[32];
	char l4_str[32];

	switch (meta.l3_proto)
	{
	case ETH_P_IP:
		strcpy(l3_str, "IP");
		inet_ntop(AF_INET, &meta.src, src_str, INET_ADDRSTRLEN);
		inet_ntop(AF_INET, &meta.dst, dst_str, INET_ADDRSTRLEN);
		break;
	case ETH_P_IPV6:
		strcpy(l3_str, "IP6");
		inet_ntop(AF_INET6, &meta.srcv6, src_str, INET6_ADDRSTRLEN);
		inet_ntop(AF_INET6, &meta.dstv6, dst_str, INET6_ADDRSTRLEN);
		break;
	case ETH_P_ARP:
		strcpy(l3_str, "ARP");
		break;
	default:
		sprintf(l3_str, "%04x", meta.l3_proto);
	}

	switch (meta.l4_proto)
	{
	case IPPROTO_TCP:
		sprintf(l4_str, "TCP seq %d", ntohl(meta.seq));
		break;
	case IPPROTO_UDP:
		strcpy(l4_str, "UDP");
		break;
	case IPPROTO_ICMP:
		strcpy(l4_str, "ICMP");
		break;
	default:
		strcpy(l4_str, "");
	}

	printf("%lld.%06lld %s %s:%d > %s:%d %s, length %d\n",
		   timestamp / NS_IN_SEC, (timestamp % NS_IN_SEC) / 1000,
		   l3_str,
		   src_str, ntohs(meta.port16[0]),
		   dst_str, ntohs(meta.port16[1]),
		   l4_str, meta.data_len);
}

int event_printer(struct perf_event_sample *sample)
{
	int i;

	metaPrint(sample->meta, sample->timestamp);

	if (DUMPPAYLOAD)
	{ /* print payload hex */
		printf("\t");
		for (i = 0; i < sample->meta.pkt_len; i++)
		{
			printf("%02x", sample->pkt_data[i]);

			if ((i + 1) % 16 == 0)
				printf("\n\t");
			else if ((i + 1) % 2 == 0)
				printf(" ");
		}
		printf("\n");
	}
	return LIBBPF_PERF_EVENT_CONT;
}

static enum bpf_perf_event_ret pacheco(struct perf_event_header *hdr, void *private_data) {
	enum bpf_perf_event_ret hmm;
	return hmm;
}

static enum bpf_perf_event_ret event_received(void *event, void *printfn)
{
	int (*print_fn)(struct perf_event_sample *) = printfn;
	struct perf_event_sample *sample = event;

	if (sample->header.type == PERF_RECORD_SAMPLE)
		return print_fn(sample);
	else
		return LIBBPF_PERF_EVENT_CONT;
}

int event_poller(struct perf_event_mmap_page **mem_buf, int *sys_fds,
				 int cpu_total)
{
	struct pollfd poll_fds[MAX_CPU];
	void *buf = NULL;
	size_t len = 0;
	int total_size;
	int pagesize;
	int res;
	int n;

	/* Create pollfd struct to contain poller info */
	for (n = 0; n < cpu_total; n++)
	{
		poll_fds[n].fd = sys_fds[n];
		poll_fds[n].events = POLLIN;
	}

	pagesize = getpagesize();
	total_size = PAGE_CNT * pagesize;
	for (;;)
	{
		/* Poll fds for events, 250ms timeout */
		poll(poll_fds, cpu_total, 250);

		for (n = 0; n < cpu_total; n++)
		{
			if (poll_fds[n].revents)
			{ /* events found */
				res = bpf_perf_event_read_simple(mem_buf[n],
												 total_size,
												 pagesize,
												 &buf, &len,
												 (bpf_perf_event_print_t)event_received,
												 event_printer);
				if (res != LIBBPF_PERF_EVENT_CONT)
					break;
			}
		}
	}
	free(buf);
}

int setup_perf_poller(int perf_map_fd, int *sys_fds, int cpu_total,
					  struct perf_event_mmap_page **mem_buf)
{
	struct perf_event_attr attr = {
		.sample_type = PERF_SAMPLE_RAW | PERF_SAMPLE_TIME,
		.type = PERF_TYPE_SOFTWARE,
		.config = PERF_COUNT_SW_BPF_OUTPUT,
		.wakeup_events = 1,
	};
	int mmap_size;
	int pmu;
	int n;

	mmap_size = getpagesize() * (PAGE_CNT + 1);

	for (n = 0; n < cpu_total; n++)
	{
		/* create perf fd for each thread */
		pmu = sys_perf_event_open(&attr, -1, n, -1, 0);
		if (pmu < 0)
		{
			printf("error setting up perf fd\n");
			return 1;
		}
		/* enable PERF events on the fd */
		ioctl(pmu, PERF_EVENT_IOC_ENABLE, 0);

		/* give fd a memory buf to write to */
		mem_buf[n] = mmap(NULL, mmap_size, PROT_READ | PROT_WRITE,
						  MAP_SHARED, pmu, 0);
		if (mem_buf[n] == MAP_FAILED)
		{
			printf("error creating mmap\n");
			return 1;
		}
		/* point eBPF map entries to fd */
		assert(!bpf_map_update_elem(perf_map_fd, &n, &pmu, BPF_ANY));
		sys_fds[n] = pmu;
	}
	return 0;
}

static void usage(const char *prog)
{
	fprintf(stderr,
			"%s -i interface [OPTS]\n\n"
			"OPTS:\n"
			" -h        help\n"
			" -H        Hardware Mode (XDPOFFLOAD)\n"
			" -N        Native Mode (XDPDRV)\n"
			" -S        SKB Mode (XDPGENERIC)\n"
			" -x        Show packet payload\n",
			prog);
}

/**
 * @brief Load the eBPF program
 */
int main(int argc, char **argv)
{
	static struct perf_event_mmap_page *mem_buf[MAX_CPU];
	struct bpf_prog_load_attr prog_load_attr = {
		.prog_type = BPF_PROG_TYPE_XDP,
		.file = "prog.bpf.o",
	};
	struct bpf_map *perf_map;
	struct bpf_object *obj;
	int sys_fds[MAX_CPU];
	int perf_map_fd;
	int prog_fd;
	int n_cpus;
	int opt;

	XDPFLAGS = XDP_FLAGS_SKB_MODE;
	n_cpus = get_nprocs();
	DUMPPAYLOAD = 0;

	if (optind == argc)
	{
		usage(basename(argv[0]));
		return -1;
	}

	while ((opt = getopt(argc, argv, "hHi:NSx")) != -1)
	{
		switch (opt)
		{
		case 'h':
			usage(basename(argv[0]));
			return 0;
		case 'H':
			XDPFLAGS = XDP_FLAGS_HW_MODE;
			prog_load_attr.ifindex = IFINDEX; /* set HW ifindex */
			break;
		case 'i':
			IFINDEX = if_nametoindex(optarg);
			break;
		case 'N':
			XDPFLAGS = XDP_FLAGS_DRV_MODE;
			break;
		case 'S':
			XDPFLAGS = XDP_FLAGS_SKB_MODE;
			break;
		case 'x':
			DUMPPAYLOAD = 1;
			break;
		default:
			printf("incorrect usage\n");
			usage(basename(argv[0]));
			return -1;
		}
	}

	if (IFINDEX == 0)
	{
		printf("error, invalid interface\n");
		return -1;
	}

	/* use libbpf to load program */
	if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
	{
		printf("error with loading file\n");
		return -1;
	}

	if (prog_fd < 1)
	{
		printf("error creating prog_fd\n");
		return -1;
	}

	signal(SIGINT, _unloadProg);
	signal(SIGTERM, _unloadProg);

	/* use libbpf to link program to interface with corresponding flags */
	if (bpf_set_link_xdp_fd(IFINDEX, prog_fd, XDPFLAGS) < 0)
	{
		printf("error setting fd onto xdp\n");
		return -1;
	}

	perf_map = bpf_object__find_map_by_name(obj, "perf_map");
	perf_map_fd = bpf_map__fd(perf_map);

	if (perf_map_fd < 0)
	{
		printf("error cannot find map\n");
		return -1;
	}

	/* Initialize perf rings */
	if (setup_perf_poller(perf_map_fd, sys_fds, n_cpus, &mem_buf[0]))
		return -1;

	event_poller(mem_buf, sys_fds, n_cpus);

	return 0;
}