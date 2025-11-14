#include "vmlinux.h"
#include <bpf/bpf_helpers.h>
#include <bpf/bpf_tracing.h>
#include <bpf/bpf_core_read.h>

char LICENSE[] SEC("license") = "GPL";

#define PROTO_TCP 6
#define PROTO_UDP 17
#define PROTO_ICMP 1
#define PROTO_OTHER 0

struct traffic_key {
    __u32 pid;
    __u8 protocol;
    __u16 port;
    __u32 ip;
};

struct traffic_stats {
    __u64 bytes_sent;
    __u64 bytes_recv;
    __u64 packets_sent;
    __u64 packets_recv;
    __u64 last_update_ns;
};

struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 10240);
    __type(key, struct traffic_key);
    __type(value, struct traffic_stats);
} traffic_map SEC(".maps");

struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 256);
    __type(key, __u8);
    __type(value, __u64);
} protocol_totals SEC(".maps");

struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 1024);
    __type(key, struct traffic_key);
    __type(value, __u64);
} anomaly_map SEC(".maps");

struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 10240);
    __type(key, __u32);
    __type(value, struct traffic_stats);
} pid_stats SEC(".maps");

static void update_traffic_stats(struct traffic_key *key, __u64 bytes, bool is_sent) {
    __u64 now = bpf_ktime_get_ns();

    __u64 *proto_total_bytes = bpf_map_lookup_elem(&protocol_totals, &key->protocol);
    if (proto_total_bytes) {
        *proto_total_bytes += bytes;
    } else {
        bpf_map_update_elem(&protocol_totals, &key->protocol, &bytes, BPF_ANY);
    }

    struct traffic_stats *stats = bpf_map_lookup_elem(&traffic_map, key);
    if (stats) {
        if (is_sent) {
            stats->bytes_sent += bytes;
            stats->packets_sent++;
        } else {
            stats->bytes_recv += bytes;
            stats->packets_recv++;
        }
        stats->last_update_ns = now;
        bpf_map_update_elem(&traffic_map, key, stats, BPF_ANY);
    } else {
        struct traffic_stats new_stats = { .last_update_ns = now };
        if (is_sent) {
            new_stats.bytes_sent = bytes;
            new_stats.packets_sent = 1;
        } else {
            new_stats.bytes_recv = bytes;
            new_stats.packets_recv = 1;
        }
        bpf_map_update_elem(&traffic_map, key, &new_stats, BPF_ANY);
    }

    struct traffic_stats *pid_stat = bpf_map_lookup_elem(&pid_stats, &key->pid);
    if (!pid_stat) {
        struct traffic_stats new_pid_stat = {};
        new_pid_stat.last_update_ns = now;
        if (is_sent) {
            new_pid_stat.bytes_sent = bytes;
            new_pid_stat.packets_sent = 1;
        } else {
            new_pid_stat.bytes_recv = bytes;
            new_pid_stat.packets_recv = 1;
        }
        bpf_map_update_elem(&pid_stats, &key->pid, &new_pid_stat, BPF_ANY);
    } else {
        if (is_sent) {
            pid_stat->bytes_sent += bytes;
            pid_stat->packets_sent++;
        } else {
            pid_stat->bytes_recv += bytes;
            pid_stat->packets_recv++;
        }
        pid_stat->last_update_ns = now;
        bpf_map_update_elem(&pid_stats, &key->pid, pid_stat, BPF_ANY);
    }
}

static __always_inline __u16 ntohs(__u16 x) {
    return ((x & 0xff00) >> 8) | ((x & 0x00ff) << 8);
}

SEC("tracepoint/syscalls/sys_enter_sendto")
int on_sys_enter_sendto(struct trace_event_raw_sys_enter *ctx) {
    struct traffic_key key = {};
    
    __u64 pid_tgid = bpf_get_current_pid_tgid();
    __u32 pid = pid_tgid >> 32;
    if (pid == 0) return 0;
    
    key.pid = pid;
    __u64 bytes = ctx->args[2];
    if (bytes == 0) return 0;
    
    void *addr_ptr = (void *)ctx->args[4];
    if (addr_ptr) {
        __u16 addr_family;
        if (bpf_probe_read_user(&addr_family, sizeof(addr_family), addr_ptr) == 0) {
            if (addr_family == 2) {
                struct sockaddr_in sin = {};
                if (bpf_probe_read_user(&sin, sizeof(sin), addr_ptr) == 0) {
                    key.ip = sin.sin_addr.s_addr;
                    key.port = ntohs(sin.sin_port);
                }
            }
        }
    }
    
    key.protocol = PROTO_UDP;
    update_traffic_stats(&key, bytes, true);
    return 0;
}

SEC("tracepoint/syscalls/sys_enter_recvfrom")
int on_sys_enter_recvfrom(struct trace_event_raw_sys_enter *ctx) {
    struct traffic_key key = {};
    
    __u64 pid_tgid = bpf_get_current_pid_tgid();
    __u32 pid = pid_tgid >> 32;
    if (pid == 0) return 0;
    
    key.pid = pid;
    __u64 bytes = ctx->args[2];
    if (bytes == 0) bytes = 1;
    
    key.protocol = PROTO_UDP;
    key.port = 0;
    key.ip = 0;
    
    update_traffic_stats(&key, bytes, false);
    return 0;
}

SEC("tracepoint/syscalls/sys_enter_sendmsg")
int on_sys_enter_sendmsg(struct trace_event_raw_sys_enter *ctx) {
    struct traffic_key key = {};
    
    __u64 pid_tgid = bpf_get_current_pid_tgid();
    __u32 pid = pid_tgid >> 32;
    if (pid == 0) return 0;
    
    key.pid = pid;
    void *msg_ptr = (void *)ctx->args[1];
    __u64 bytes = 0;
    
    if (msg_ptr) {
        struct msghdr *msg = (struct msghdr *)msg_ptr;
        __u64 count = BPF_CORE_READ(msg, msg_iter.count);
        bytes = count > 0 ? count : 1;
    }
    
    if (bytes == 0) bytes = 1;
    
    if (msg_ptr) {
        struct msghdr msg = {};
        if (bpf_probe_read_user(&msg, sizeof(msg), msg_ptr) == 0) {
            if (msg.msg_name) {
                __u16 addr_family;
                if (bpf_probe_read_user(&addr_family, sizeof(addr_family), msg.msg_name) == 0) {
                    if (addr_family == 2) {
                        struct sockaddr_in sin = {};
                        if (bpf_probe_read_user(&sin, sizeof(sin), msg.msg_name) == 0) {
                            key.ip = sin.sin_addr.s_addr;
                            key.port = ntohs(sin.sin_port);
                        }
                    }
                }
            }
        }
    }
    
    key.protocol = PROTO_TCP;
    update_traffic_stats(&key, bytes, true);
    return 0;
}

SEC("tracepoint/syscalls/sys_enter_recvmsg")
int on_sys_enter_recvmsg(struct trace_event_raw_sys_enter *ctx) {
    struct traffic_key key = {};
    
    __u64 pid_tgid = bpf_get_current_pid_tgid();
    __u32 pid = pid_tgid >> 32;
    if (pid == 0) return 0;
    
    key.pid = pid;
    void *msg_ptr = (void *)ctx->args[1];
    __u64 bytes = 0;
    
    if (msg_ptr) {
        struct msghdr msg = {};
        if (bpf_probe_read_user(&msg, sizeof(msg), msg_ptr) == 0) {
            __u64 count = 0;
            void *iter_ptr = (void *)&msg.msg_iter;
            if (bpf_probe_read_user(&count, sizeof(count), 
                                    (void *)((char *)iter_ptr + offsetof(struct iov_iter, count))) == 0) {
                bytes = count;
            }
            if (bytes == 0) bytes = 1;
        }
    }
    
    if (bytes == 0) bytes = 1;
    
    key.protocol = PROTO_TCP;
    key.port = 0;
    key.ip = 0;
    
    update_traffic_stats(&key, bytes, false);
    return 0;
}
