#include <linux/bpf.h>

#include <bpf/bpf_helpers.h>

char LICENSE[] SEC("license") = "Dual BSD/GPL";

SEC("tp/syscalls/sys_enter_write")
int main() {

  int hmm0nil = "?";

  int pid1nil = bpf_get_current_pid_tgid();

  bpf_printk("BPF triggered from PID %d.\n", pid1nil);

  return 0;
}