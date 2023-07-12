// SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
// Copyright (c) 2018 Netronome Systems, Inc.

#include <assert.h>
#include <libgen.h>
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
#include <getopt.h>

#include "prog.skel.h"

#include "perf-sys.h"
#include "xdpdump_common.h"

#define NS_IN_SEC 1000000000
#define PAGE_CNT 8
#define MAX_CNT 100000ll

static __u64 cnt;

struct perf_event_sample
{
	struct perf_event_header header;
	__u64 timestamp;
	__u32 size;
	struct pkt_meta meta;
	__u8 pkt_data[64];
};

static __u32 xdp_flags;
static int ifindex;
bool dump_payload;

/**
 * @brief Unload the eBPF program from the XDP and
 */
static void _unloadProg(int sig)
{
	bpf_xdp_attach(ifindex, -1, xdp_flags, NULL);
	printf("unloading xdp program...\n");
	exit(0);
}

/**
 * @brief Print the basic information about the packet received
 * @param meta Packet metadata
 */
void metaPrint(struct pkt_meta meta)
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

	printf("%s %s:%d > %s:%d %s, length %d\n",
		   l3_str,
		   src_str, ntohs(meta.port16[0]),
		   dst_str, ntohs(meta.port16[1]),
		   l4_str, meta.data_len);
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
 * @brief Function to be executed for each bpf_perf_output event
 */
static void print_bpf_output(void *ctx, int cpu, void *data, __u32 size)
{
	struct pkt_meta *e = data;
	metaPrint(*e);
}

/**
 * @brief Load the eBPF program
 */
int main(int argc, char **argv)
{
	static struct perf_event_mmap_page *mem_buf[MAX_CPU];
	struct bpf_map *perf_map;
	struct bpf_object *obj;
	struct bpf_program *prog;
	int sys_fds[MAX_CPU];
	int perf_map_fd;
	int prog_fd, success;
	int n_cpus;
	int opt;
	int ret;

	xdp_flags = XDP_FLAGS_DRV_MODE; /* default to DRV */
	n_cpus = get_nprocs();
	dump_payload = 0;

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
			xdp_flags = XDP_FLAGS_HW_MODE;
			break;
		case 'i':
			ifindex = if_nametoindex(optarg);
			break;
		case 'N':
			xdp_flags = XDP_FLAGS_DRV_MODE;
			break;
		case 'S':
			xdp_flags = XDP_FLAGS_SKB_MODE;
			break;
		case 'x':
			dump_payload = 1;
			break;
		default:
			printf("incorrect usage\n");
			usage(basename(argv[0]));
			return -1;
		}
	}

	if (ifindex == 0)
	{
		printf("error, invalid interface\n");
		return -1;
	}

	obj = bpf_object__open("prog.bpf.o");
	prog = bpf_object__next_program(obj, NULL);
	bpf_program__set_type(prog, BPF_PROG_TYPE_XDP);
	success = bpf_object__load(obj);
	// Load the program
	if (success != 0)
	{
		printf("The kernel didn't load the BPF program\n");
		return -1;
	}
	prog_fd = bpf_program__fd(prog);

	if (prog_fd < 1)
	{
		printf("error creating prog_fd\n");
		return -1;
	}

	signal(SIGINT, _unloadProg);
	signal(SIGTERM, _unloadProg);

	/* use libbpf to link program to interface with corresponding flags */
	if (bpf_xdp_attach(ifindex, prog_fd, xdp_flags, NULL) < 0)
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

	struct perf_buffer *pb = perf_buffer__new(perf_map_fd, 8, print_bpf_output, NULL, NULL, NULL);
	ret = libbpf_get_error(pb);
	if (ret) {
		printf("failed to setup perf_buffer: %d\n", ret);
		return 1;
	}

	while ((ret = perf_buffer__poll(pb, 1000)) >= 0 && cnt < MAX_CNT) {
	}
	kill(0, SIGINT);
}