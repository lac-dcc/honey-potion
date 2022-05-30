#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>
#include <linux/version.h>

struct syscalls_enter_args {
  /**
   * This is the tracepoint arguments.
   * Defined at: /sys/kernel/debug/tracing/events/raw_syscalls/sys_enter/format
   */
    unsigned short common_type;
    unsigned char common_flags;
    unsigned char common_preempt_count;
    int common_pid;
    long id;
    unsigned long args[6];
};


SEC("tracepoint/raw_syscalls/sys_enter")
int helloWorld(struct syscalls_enter_args *ctx) {
  bpf_printk("Hello World, this is a new syscall :)");

  return 0;
}

// As this program is integrating with tracepoints, it must be GPL.
char _license[] SEC("license") = "GPL";
__u32 _version SEC("version") = LINUX_VERSION_CODE;