#include <bpf/bpf.h>
#include <bpf/libbpf.h>
#include <stdio.h>
#include <unistd.h>
#include <runtime_generic.bpf.h>
#include "CountSysCalls.skel.h"

void output(struct CountSysCalls_bpf* skel);

int main(int argc, char **argv) {
  struct CountSysCalls_bpf *skel;
  int err;

  skel = CountSysCalls_bpf__open();
  if(!skel){
    fprintf(stderr, "Skeleton failed opening.\n");
    return 1;
  }

  err = CountSysCalls_bpf__load(skel);
  if(err){
    fprintf(stderr, "Failed loading or verification of BPF skeleton.\n");
    CountSysCalls_bpf__destroy(skel);
    return -err;
  }

  err = CountSysCalls_bpf__attach(skel);
  if(err){
    fprintf(stderr, "Failed attaching BPF skeleton.\n");
    CountSysCalls_bpf__destroy(skel);
    return -err;
  }

  output(skel);
}
  void output(struct CountSysCalls_bpf* skel) {
    int key, success;
    Generic value = (Generic){0};
  /* Printing map of name Count_Sys_Calls_Invoked */
  struct bpf_map* Count_Sys_Calls_Invoked = skel->maps.Count_Sys_Calls_Invoked;
  int Count_Sys_Calls_Invoked_fd = bpf_map__fd(Count_Sys_Calls_Invoked);
  while(1){
    printf("\e[1;1H\e[2J");
    printf("Count_Sys_Calls_Invoked:\n");
    key = 0;
success = bpf_map_lookup_elem(Count_Sys_Calls_Invoked_fd, &key, &value);
if(success == 0){
  printf("%s %ld\n", "Syscall: enter_read (0) | Qtt:", value.value.integer);
}
else
{
  printf("Element %s failed to print with key %d.\n", "Syscall: enter_read (0) | Qtt:", 0);
}
key = 1;
success = bpf_map_lookup_elem(Count_Sys_Calls_Invoked_fd, &key, &value);
if(success == 0){
  printf("%s %ld\n", "Syscall: enter_write (1) | Qtt:", value.value.integer);
}
else
{
  printf("Element %s failed to print with key %d.\n", "Syscall: enter_write (1) | Qtt:", 1);
}
key = 62;
success = bpf_map_lookup_elem(Count_Sys_Calls_Invoked_fd, &key, &value);
if(success == 0){
  printf("%s %ld\n", "SysCall: enter_kill (62) | Qtt:", value.value.integer);
}
else
{
  printf("Element %s failed to print with key %d.\n", "SysCall: enter_kill (62) | Qtt:", 62);
}
key = 83;
success = bpf_map_lookup_elem(Count_Sys_Calls_Invoked_fd, &key, &value);
if(success == 0){
  printf("%s %ld\n", "SysCall: enter_mkdir (83) | Qtt:", value.value.integer);
}
else
{
  printf("Element %s failed to print with key %d.\n", "SysCall: enter_mkdir (83) | Qtt:", 83);
}
key = 318;
success = bpf_map_lookup_elem(Count_Sys_Calls_Invoked_fd, &key, &value);
if(success == 0){
  printf("%s %ld\n", "SysCall: enter_getrandom (318) | Qtt:", value.value.integer);
}
else
{
  printf("Element %s failed to print with key %d.\n", "SysCall: enter_getrandom (318) | Qtt:", 318);
}

        sleep(1);
      }
    }
