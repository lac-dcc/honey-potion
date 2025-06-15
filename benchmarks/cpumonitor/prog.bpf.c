#include "vmlinux.h"
#include <bpf/bpf_helpers.h>
#include <bpf/bpf_tracing.h>
#include <bpf/bpf_core_read.h>

char LICENSE[] SEC("license") = "GPL";

// Maps
struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 10240);
    __type(key, u32);
    __type(value, u64);
} start_time SEC(".maps"), syscall_start SEC(".maps"), kernel_time SEC(".maps"), user_time SEC(".maps");

// Helper map to temporarily store kernel time during a run
struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 10240);
    __type(key, u32);
    __type(value, u64);
} run_kernel_time SEC(".maps");

SEC("tracepoint/sched/sched_switch")
int on_sched_switch(struct trace_event_raw_sched_switch *ctx) {
    u64 ts = bpf_ktime_get_ns();
    u32 prev_pid = ctx->prev_pid;
    u32 next_pid = ctx->next_pid;

    // Compute time delta for previous process
    u64 *start = bpf_map_lookup_elem(&start_time, &prev_pid);
    if (start) {
        u64 delta = ts - *start;

        u64 ktime = 0;
        u64 *kstart = bpf_map_lookup_elem(&run_kernel_time, &prev_pid);
        if (kstart) {
            ktime = *kstart;
            bpf_map_delete_elem(&run_kernel_time, &prev_pid);
        }

        // Update user time = delta - time spent in syscalls during this run
        if (ktime < delta) {
            u64 utime = delta - ktime;
            u64 *ut = bpf_map_lookup_elem(&user_time, &prev_pid);
            if (ut) *ut += utime;
            else bpf_map_update_elem(&user_time, &prev_pid, &utime, BPF_ANY);
        }

        // Add the kernel time from this slice to total kernel time
        if (ktime > 0) {
            u64 *kt = bpf_map_lookup_elem(&kernel_time, &prev_pid);
            if (kt) *kt += ktime;
            else bpf_map_update_elem(&kernel_time, &prev_pid, &ktime, BPF_ANY);
        }

        bpf_map_delete_elem(&start_time, &prev_pid);
    }

    // Start time for next process
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

        // Track kernel time only for the current run
        u64 *k = bpf_map_lookup_elem(&run_kernel_time, &pid);
        if (k) *k += delta;
        else bpf_map_update_elem(&run_kernel_time, &pid, &delta, BPF_ANY);

        bpf_map_delete_elem(&syscall_start, &pid);
    }
    return 0;
}
