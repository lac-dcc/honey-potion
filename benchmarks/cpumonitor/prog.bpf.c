#include "vmlinux.h"
#include <bpf/bpf_helpers.h>
#include <bpf/bpf_tracing.h>
#include <bpf/bpf_core_read.h>

char LICENSE[] SEC("license") = "GPL";

struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 10240);
    __type(key, u32);
    __type(value, u64);
} start_time SEC(".maps"), syscall_start SEC(".maps"), total_time SEC(".maps"), kernel_time SEC(".maps");

SEC("tracepoint/sched/sched_switch")
int on_sched_switch(struct trace_event_raw_sched_switch *ctx) {
    u64 ts = bpf_ktime_get_ns();
    u32 prev_pid = ctx->prev_pid;
    u32 next_pid = ctx->next_pid;

    u64 *start = bpf_map_lookup_elem(&start_time, &prev_pid);
    if (start) {
        u64 delta = ts - *start;
        u64 *total = bpf_map_lookup_elem(&total_time, &prev_pid);
        if (total) *total += delta;
        else bpf_map_update_elem(&total_time, &prev_pid, &delta, BPF_ANY);
        bpf_map_delete_elem(&start_time, &prev_pid);
    }

    bpf_map_update_elem(&start_time, &next_pid, &ts, BPF_ANY);
    return 0;
}

SEC("tracepoint/raw_syscalls/sys_enter")
int on_sys_enter(struct trace_event_raw_sys_enter *ctx) {
    u32 pid = bpf_get_current_pid_tgid() >> 32;
    u64 ts = bpf_ktime_get_ns();
    bpf_map_update_elem(&syscall_start, &pid, &ts, BPF_ANY);
    return 0;
}

SEC("tracepoint/raw_syscalls/sys_exit")
int on_sys_exit(struct trace_event_raw_sys_exit *ctx) {
    u32 pid = bpf_get_current_pid_tgid() >> 32;
    u64 ts = bpf_ktime_get_ns();
    u64 *start = bpf_map_lookup_elem(&syscall_start, &pid);
    if (start) {
        u64 delta = ts - *start;
        u64 *kt = bpf_map_lookup_elem(&kernel_time, &pid);
        if (kt) *kt += delta;
        else bpf_map_update_elem(&kernel_time, &pid, &delta, BPF_ANY);
        bpf_map_delete_elem(&syscall_start, &pid);
    }
    return 0;
}
