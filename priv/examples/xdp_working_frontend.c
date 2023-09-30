#include <linux/if_link.h>
#include <bpf/bpf.h>
#include <bpf/libbpf.h>
#include <stdio.h>
#include <unistd.h>
#include <runtime_generic.bpf.h>
#include <net/if.h>
#include "XdpExample.skel.h"
#include <signal.h>

void output();

int flags;
unsigned int ifindex;

void _unloadProg()
{
  bpf_xdp_attach(ifindex, -1, flags, NULL);
  printf("unloading xdp program...\n");
  exit(0);
}

int main(int argc, char **argv)
{
  struct XdpExample_bpf *skel;
  int err;

  signal(SIGINT, _unloadProg);
  signal(SIGTERM, _unloadProg);

  skel = XdpExample_bpf__open();
  if (!skel)
  {
    fprintf(stderr, "Skeleton failed opening.\n");
    return 1;
  }

  err = XdpExample_bpf__load(skel);
  if (err)
  {
    fprintf(stderr, "Failed loading or verification of BPF skeleton.\n");
    XdpExample_bpf__destroy(skel);
    return -err;
  }

  err = XdpExample_bpf__attach(skel);
  if (err)
  {
    fprintf(stderr, "Failed attaching BPF skeleton.\n");
    XdpExample_bpf__destroy(skel);
    return -err;
  }

  flags = XDP_FLAGS_SKB_MODE;
  int fd = bpf_program__fd(skel->progs.main_func);
  ifindex = if_nametoindex("wlp60s0");

  if (bpf_xdp_attach(ifindex, fd, flags, NULL) < 0)
	{
		printf("error attach fd onto xdp\n");
		return -1;
	}

  output(skel);
}
void output()
{
  int maxPoints = 3;
  int points = 0;
  while (1)
  {
    fflush(0);

    printf("eBPF program loaded and executing");
    for (int i = 0; i < (maxPoints + 1); i++)
      printf((i < points) ? "." : " ");

    points = (points + 1) % (maxPoints + 1);
    printf("\r");

    sleep(1);
  }
}
