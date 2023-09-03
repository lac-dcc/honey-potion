#include <bpf/bpf.h>
#include <bpf/libbpf.h>
#include <stdio.h>
#include <unistd.h>
#include <runtime_generic.bpf.h>
#include "MaxMaps.skel.h"

void output(struct MaxMaps_bpf* skel, uint time, bool all);
void choose_output(struct MaxMaps_bpf* skel, bool all);
void output_opt(struct MaxMaps_bpf* skel);
void output_all(struct MaxMaps_bpf* skel);

int main(int argc, char **argv) {

  bool printAll = false; // Prints only print:true otherwise
  uint lifeTime = 0; // If 0 -> infinite.

  int opt;
  while((opt = getopt(argc, argv, "pt:")) != -1){
    switch(opt){
      case 'p': printAll = true; break;
      case 't': lifeTime = atoi(optarg);
    }
  } 

  struct MaxMaps_bpf *skel;
  int err;

  skel = MaxMaps_bpf__open();
  if(!skel){
    fprintf(stderr, "Skeleton failed opening.\n");
    return 1;
  }

  err = MaxMaps_bpf__load(skel);
  if(err){
    fprintf(stderr, "Failed loading or verification of BPF skeleton.\n");
    MaxMaps_bpf__destroy(skel);
    return -err;
  }

  err = MaxMaps_bpf__attach(skel);
  if(err){
    fprintf(stderr, "Failed attaching BPF skeleton.\n");
    MaxMaps_bpf__destroy(skel);
    return -err;
  }

  output(skel, lifeTime, printAll);
}

void output(struct MaxMaps_bpf* skel, uint time, bool all){
  if(time == 0){
    while(1){
      choose_output(skel, all);
      sleep(1);
    }
  } else {
    time++;
    while(1){
      choose_output(skel, all);
      if(!--time) break;
      sleep(1);
    }
  }
}

void choose_output(struct MaxMaps_bpf* skel, bool all){
  if(all) output_all(skel);
  else output_opt(skel);
}

void output_opt(struct MaxMaps_bpf* skel){    int maxPoints = 3;
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

void output_all(struct MaxMaps_bpf* skel) {
  int key, success;
  Generic value = (Generic){0};

  printf("\e[1;1H\e[2J");

  /* Printing map of name Second_Example_map */
  struct bpf_map* Second_Example_map = skel->maps.Example_map;
  int Second_Example_map_fd = bpf_map__fd(Second_Example_map);
  printf("Second_Example_map:\n");
  key = 0;
  int Second_Example_map_prev_key = 0;
  success = bpf_map_get_next_key(Second_Example_map_fd, NULL, &key); 
  while(success == 0){
    success = bpf_map_lookup_elem(Second_Example_map_fd, &key, &value);
    if (success == 0) {
      printf("Entry %d: %ld\n", key, value.value.integer);
    }
    Second_Example_map_prev_key = key;
    success = bpf_map_get_next_key(Second_Example_map_fd, &Second_Example_map_prev_key, &key);
  }
  }
