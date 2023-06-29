#include <bpf/bpf.h>
#include <bpf/libbpf.h>
#include <stdio.h>
#include <unistd.h>
#include <runtime_generic.bpf.h>
#include "Honey_Tuple.skel.h"

void output();

int main(int argc, char **argv) {
  struct Honey_Tuple_bpf *skel;
  int err;

  skel = Honey_Tuple_bpf__open();
  if(!skel){
    fprintf(stderr, "Skeleton failed opening.\n");
    return 1;
  }

  err = Honey_Tuple_bpf__load(skel);
  if(err){
    fprintf(stderr, "Failed loading or verification of BPF skeleton.\n");
    Honey_Tuple_bpf__destroy(skel);
    return -err;
  }

  err = Honey_Tuple_bpf__attach(skel);
  if(err){
    fprintf(stderr, "Failed attaching BPF skeleton.\n");
    Honey_Tuple_bpf__destroy(skel);
    return -err;
  }

  output(skel);
}
void output() {
    int maxPoints = 3;
    int points = 0;
    while(1) {
        fflush(0);

        printf("eBPF program loaded and executing");
        for (int i = 0; i < (maxPoints + 1); i++) printf((i < points)? ".": " ");

        points = (points + 1) % (maxPoints + 1);
        printf("\r");

        sleep(1);
    }
}
