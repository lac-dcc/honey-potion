#include <bpf/bpf.h>
#include <bpf/libbpf.h>
#include <stdio.h>
#include <unistd.h>
#include <runtime_generic.bpf.h>
#include "Honey_Maps.skel.h"

void output(struct Honey_Maps_bpf* skel);

int main(int argc, char **argv) {
  struct Honey_Maps_bpf *skel;
  int err;

  skel = Honey_Maps_bpf__open();
  if(!skel){
    fprintf(stderr, "Skeleton failed opening.\n");
    return 1;
  }

  err = Honey_Maps_bpf__load(skel);
  if(err){
    fprintf(stderr, "Failed loading or verification of BPF skeleton.\n");
    Honey_Maps_bpf__destroy(skel);
    return -err;
  }

  err = Honey_Maps_bpf__attach(skel);
  if(err){
    fprintf(stderr, "Failed attaching BPF skeleton.\n");
    Honey_Maps_bpf__destroy(skel);
    return -err;
  }

  output(skel);
}
  void output(struct Honey_Maps_bpf* skel) {
    int key, success;
    Generic value = (Generic){0};
  /* Printing map of name Example_map */
  struct bpf_map* Example_map = skel->maps.Example_map;
  int Example_map_fd = bpf_map__fd(Example_map);
  while(1){
    printf("\e[1;1H\e[2J");
    printf("Example_map:\n");
    key = 0;
success = bpf_map_lookup_elem(Example_map_fd, &key, &value);
if(success == 0){
  printf("%s %ld\n", "Entry 0:", value.value.integer);
}
else
{
  printf("Element %s failed to print with key %d.\n", "Entry 0:", 0);
}
key = 1;
success = bpf_map_lookup_elem(Example_map_fd, &key, &value);
if(success == 0){
  printf("%s %ld\n", "Entry 1:", value.value.integer);
}
else
{
  printf("Element %s failed to print with key %d.\n", "Entry 1:", 1);
}
key = 2;
success = bpf_map_lookup_elem(Example_map_fd, &key, &value);
if(success == 0){
  printf("%s %ld\n", "Entry 2:", value.value.integer);
}
else
{
  printf("Element %s failed to print with key %d.\n", "Entry 2:", 2);
}

        sleep(1);
      }
    }
