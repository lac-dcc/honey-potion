#include "vmlinux.h"
#include <bpf/bpf_helpers.h>
#include <bpf/bpf_tracing.h>

char LICENSE[] SEC("license") = "GPL";

struct mem_event {
    u64 timestamp;
    u32 pid;
    u32 tgid;
    u64 size;
    u64 address;
    u8 event_type;
    char comm[16];
};

struct mem_stats {
    u64 total_allocated;
    u64 total_freed;
    u64 current_usage;
    u64 peak_usage;
    u64 alloc_count;
    u64 free_count;
    u64 mmap_count;
    u64 munmap_count;
    u64 last_update;
};

struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 10240);
    __type(key, u32);
    __type(value, struct mem_stats);
} mem_stats_map SEC(".maps");

struct {
    __uint(type, BPF_MAP_TYPE_RINGBUF);
    __uint(max_entries, 256 * 1024);
} mem_events SEC(".maps");

struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 10240);
    __type(key, u64);
    __type(value, u64);
} active_allocs SEC(".maps");

static inline u32 get_current_pid(void) {
    return bpf_get_current_pid_tgid() & 0xFFFFFFFF;
}

static inline u32 get_current_tgid(void) {
    return bpf_get_current_pid_tgid() >> 32;
}

static inline void update_mem_stats(u32 pid, u64 size, u8 event_type) {
    struct mem_stats *stats = bpf_map_lookup_elem(&mem_stats_map, &pid);
    if (!stats) {
        struct mem_stats new_stats = {};
        new_stats.last_update = bpf_ktime_get_ns();
        bpf_map_update_elem(&mem_stats_map, &pid, &new_stats, BPF_NOEXIST);
        stats = bpf_map_lookup_elem(&mem_stats_map, &pid);
        if (!stats) return;
    }

    stats->last_update = bpf_ktime_get_ns();

    switch (event_type) {
        case 0:
            stats->total_allocated += size;
            stats->current_usage += size;
            stats->alloc_count++;
            if (stats->current_usage > stats->peak_usage) {
                stats->peak_usage = stats->current_usage;
            }
            break;
        case 1:
            if (stats->current_usage >= size) {
                stats->current_usage -= size;
            }
            stats->total_freed += size;
            stats->free_count++;
            break;
        case 2:
            stats->mmap_count++;
            stats->current_usage += size;
            if (stats->current_usage > stats->peak_usage) {
                stats->peak_usage = stats->current_usage;
            }
            break;
        case 3:
            if (stats->current_usage >= size) {
                stats->current_usage -= size;
            }
            stats->munmap_count++;
            break;
    }
}

SEC("tracepoint/syscalls/sys_enter_mmap")
int trace_mmap_enter(struct trace_event_raw_sys_enter *ctx) {
    u32 pid = get_current_pid();
    u32 tgid = get_current_tgid();
    u64 length = ctx->args[1];
    
    if (length >= 1024) {
        update_mem_stats(pid, length, 2);
        
        struct mem_event *event = bpf_ringbuf_reserve(&mem_events, sizeof(*event), 0);
        if (event) {
            event->timestamp = bpf_ktime_get_ns();
            event->pid = pid;
            event->tgid = tgid;
            event->size = length;
            event->address = 0;
            event->event_type = 2;
            bpf_get_current_comm(event->comm, sizeof(event->comm));
            bpf_ringbuf_submit(event, 0);
        }
    }
    
    return 0;
}

SEC("tracepoint/syscalls/sys_enter_munmap")
int trace_munmap_enter(struct trace_event_raw_sys_enter *ctx) {
    u32 pid = get_current_pid();
    u32 tgid = get_current_tgid();
    u64 length = ctx->args[1];
    
    update_mem_stats(pid, length, 3);
    
    struct mem_event *event = bpf_ringbuf_reserve(&mem_events, sizeof(*event), 0);
    if (event) {
        event->timestamp = bpf_ktime_get_ns();
        event->pid = pid;
        event->tgid = tgid;
        event->size = length;
        event->address = 0;
        event->event_type = 3;
        bpf_get_current_comm(event->comm, sizeof(event->comm));
        bpf_ringbuf_submit(event, 0);
    }
    
    return 0;
}

SEC("tracepoint/syscalls/sys_enter_brk")
int trace_brk_enter(struct trace_event_raw_sys_enter *ctx) {
    u32 pid = get_current_pid();
    u32 tgid = get_current_tgid();
    u64 addr = ctx->args[0];
    
    struct mem_event *event = bpf_ringbuf_reserve(&mem_events, sizeof(*event), 0);
    if (event) {
        event->timestamp = bpf_ktime_get_ns();
        event->pid = pid;
        event->tgid = tgid;
        event->size = 0;
        event->address = addr;
        event->event_type = 4;
        bpf_get_current_comm(event->comm, sizeof(event->comm));
        bpf_ringbuf_submit(event, 0);
    }
    
    return 0;
}