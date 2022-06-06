#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>
#include <linux/version.h>
#include "prog.h"

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

struct {
  __uint(type, BPF_MAP_TYPE_HASH);
  __uint(max_entries, 64);
  __type(key, long);
  __type(value, long);
} map SEC(".maps");


SEC("tracepoint/raw_syscalls/sys_enter")
int countSyscalls(struct syscalls_enter_args *ctx) {
    long id = ctx->id;
    int found = 0;
    long qtd = 0;

    // Check if the *id* exists in our list
    for (int i = 0; i < NSYS; i++) {
        if (SYSCALLSNAMES[i].id == id) {
            found = 1;
            break;
        }
    }

    if (found == 0)
        return 0;


    // Update the value of the ID
    long* value = (long*)bpf_map_lookup_elem(&map, &id);
    if (value == 0)
        value = &qtd;

    *value = *value + 1;
    bpf_map_update_elem(&map, &id, value, BPF_ANY);

    return 0;
}

// As this program is integrating with tracepoints, it must be GPL.
char _license[] SEC("license") = "GPL";
__u32 _version SEC("version") = LINUX_VERSION_CODE;