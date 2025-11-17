#include "vmlinux.h"
#include <bpf/bpf_helpers.h>
#include <bpf/bpf_tracing.h>

char LICENSE[] SEC("license") = "GPL";

#define OP_READ 0
#define OP_WRITE 1

struct io_key {
    __u32 pid;
    __u8 operation;  // 0 = read, 1 = write
};

struct io_stats {
    __u64 bytes_read;
    __u64 bytes_written;
    __u64 ops_read;
    __u64 ops_write;
    __u64 total_latency_ns;  // Total latency in nanoseconds
    __u64 max_latency_ns;    // Maximum latency
    __u64 min_latency_ns;    // Minimum latency
    __u64 last_update_ns;
};

struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 10240);
    __type(key, struct io_key);
    __type(value, struct io_stats);
} io_stats_map SEC(".maps");

struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 10240);
    __type(key, __u32);
    __type(value, __u64);
} io_start_time SEC(".maps");

struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 10240);
    __type(key, __u32);
    __type(value, struct io_stats);
} pid_stats SEC(".maps");

static inline __u32 get_current_pid(void) {
    return bpf_get_current_pid_tgid() >> 32;
}

static inline void update_io_stats(__u32 pid, __u8 operation, __u64 bytes, __u64 latency_ns) {
    __u64 now = bpf_ktime_get_ns();
    
    struct io_key key = {
        .pid = pid,
        .operation = operation
    };
    
    struct io_stats *stats = bpf_map_lookup_elem(&io_stats_map, &key);
    if (stats) {
        if (operation == OP_READ) {
            stats->bytes_read += bytes;
            stats->ops_read++;
        } else {
            stats->bytes_written += bytes;
            stats->ops_write++;
        }
        stats->total_latency_ns += latency_ns;
        if (latency_ns > stats->max_latency_ns) {
            stats->max_latency_ns = latency_ns;
        }
        if (stats->min_latency_ns == 0 || latency_ns < stats->min_latency_ns) {
            stats->min_latency_ns = latency_ns;
        }
        stats->last_update_ns = now;
        bpf_map_update_elem(&io_stats_map, &key, stats, BPF_ANY);
    } else {
        struct io_stats new_stats = { .last_update_ns = now };
        if (operation == OP_READ) {
            new_stats.bytes_read = bytes;
            new_stats.ops_read = 1;
        } else {
            new_stats.bytes_written = bytes;
            new_stats.ops_write = 1;
        }
        new_stats.total_latency_ns = latency_ns;
        new_stats.max_latency_ns = latency_ns;
        new_stats.min_latency_ns = latency_ns;
        bpf_map_update_elem(&io_stats_map, &key, &new_stats, BPF_ANY);
    }
    
    struct io_stats *pid_stat = bpf_map_lookup_elem(&pid_stats, &pid);
    if (!pid_stat) {
        struct io_stats new_pid_stat = { .last_update_ns = now };
        if (operation == OP_READ) {
            new_pid_stat.bytes_read = bytes;
            new_pid_stat.ops_read = 1;
        } else {
            new_pid_stat.bytes_written = bytes;
            new_pid_stat.ops_write = 1;
        }
        new_pid_stat.total_latency_ns = latency_ns;
        new_pid_stat.max_latency_ns = latency_ns;
        new_pid_stat.min_latency_ns = latency_ns;
        bpf_map_update_elem(&pid_stats, &pid, &new_pid_stat, BPF_ANY);
    } else {
        if (operation == OP_READ) {
            pid_stat->bytes_read += bytes;
            pid_stat->ops_read++;
        } else {
            pid_stat->bytes_written += bytes;
            pid_stat->ops_write++;
        }
        pid_stat->total_latency_ns += latency_ns;
        if (latency_ns > pid_stat->max_latency_ns) {
            pid_stat->max_latency_ns = latency_ns;
        }
        if (pid_stat->min_latency_ns == 0 || latency_ns < pid_stat->min_latency_ns) {
            pid_stat->min_latency_ns = latency_ns;
        }
        pid_stat->last_update_ns = now;
        bpf_map_update_elem(&pid_stats, &pid, pid_stat, BPF_ANY);
    }
}

static inline int handle_sys_enter(__u32 pid) {
    if (pid == 0) return 0;
    
    __u64 now = bpf_ktime_get_ns();
    bpf_map_update_elem(&io_start_time, &pid, &now, BPF_ANY);
    return 0;
}

static inline int handle_sys_exit(__u32 pid, __u8 operation, long ret) {
    if (pid == 0) return 0;
    
    __u64 *start = bpf_map_lookup_elem(&io_start_time, &pid);
    if (!start) return 0;
    
    __u64 now = bpf_ktime_get_ns();
    __u64 latency_ns = now - *start;
    __u64 bytes = ret > 0 ? (__u64)ret : 0;
    
    update_io_stats(pid, operation, bytes, latency_ns);
    bpf_map_delete_elem(&io_start_time, &pid);
    return 0;
}

SEC("tracepoint/syscalls/sys_enter_read")
int on_sys_enter_read(struct trace_event_raw_sys_enter *ctx) {
    return handle_sys_enter(get_current_pid());
}

SEC("tracepoint/syscalls/sys_exit_read")
int on_sys_exit_read(struct trace_event_raw_sys_exit *ctx) {
    return handle_sys_exit(get_current_pid(), OP_READ, ctx->ret);
}

SEC("tracepoint/syscalls/sys_enter_write")
int on_sys_enter_write(struct trace_event_raw_sys_enter *ctx) {
    return handle_sys_enter(get_current_pid());
}

SEC("tracepoint/syscalls/sys_exit_write")
int on_sys_exit_write(struct trace_event_raw_sys_exit *ctx) {
    return handle_sys_exit(get_current_pid(), OP_WRITE, ctx->ret);
}

SEC("tracepoint/syscalls/sys_enter_pread64")
int on_sys_enter_pread64(struct trace_event_raw_sys_enter *ctx) {
    return handle_sys_enter(get_current_pid());
}

SEC("tracepoint/syscalls/sys_exit_pread64")
int on_sys_exit_pread64(struct trace_event_raw_sys_exit *ctx) {
    return handle_sys_exit(get_current_pid(), OP_READ, ctx->ret);
}

SEC("tracepoint/syscalls/sys_enter_pwrite64")
int on_sys_enter_pwrite64(struct trace_event_raw_sys_enter *ctx) {
    return handle_sys_enter(get_current_pid());
}

SEC("tracepoint/syscalls/sys_exit_pwrite64")
int on_sys_exit_pwrite64(struct trace_event_raw_sys_exit *ctx) {
    return handle_sys_exit(get_current_pid(), OP_WRITE, ctx->ret);
}

SEC("tracepoint/syscalls/sys_enter_readv")
int on_sys_enter_readv(struct trace_event_raw_sys_enter *ctx) {
    return handle_sys_enter(get_current_pid());
}

SEC("tracepoint/syscalls/sys_exit_readv")
int on_sys_exit_readv(struct trace_event_raw_sys_exit *ctx) {
    return handle_sys_exit(get_current_pid(), OP_READ, ctx->ret);
}

SEC("tracepoint/syscalls/sys_enter_writev")
int on_sys_enter_writev(struct trace_event_raw_sys_enter *ctx) {
    return handle_sys_enter(get_current_pid());
}

SEC("tracepoint/syscalls/sys_exit_writev")
int on_sys_exit_writev(struct trace_event_raw_sys_exit *ctx) {
    return handle_sys_exit(get_current_pid(), OP_WRITE, ctx->ret);
}

