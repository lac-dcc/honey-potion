# Network Monitor - eBPF Implementation

## Overview

The Network Monitor eBPF program captures network traffic observed during send and receive syscalls. It associates transferred bytes with the originating PID, the transport protocol, and destination information whenever available. The design emphasises verifier safety, continuous collection, and efficient communication with user space.

## Collection Strategy

### Why syscalls?

1. **Process context** — `sys_enter_*` handlers execute in the caller’s context, so `bpf_get_current_pid_tgid()` yields the correct PID/TGID.
2. **Network coverage** — The syscalls `sendto`, `recvfrom`, `sendmsg`, and `recvmsg` cover common UDP and TCP socket operations.
3. **Safe address reads** — Arguments are user-space pointers; the program uses `bpf_probe_read_user()` and `BPF_CORE_READ()` to extract relevant fields safely.

### Tracepoints used

| Tracepoint                              | Primary purpose                                          |
|----------------------------------------|----------------------------------------------------------|
| `tracepoint/syscalls/sys_enter_sendto` | Count bytes sent (UDP, unconnected TCP)                  |
| `tracepoint/syscalls/sys_enter_recvfrom` | Count bytes received (UDP)                              |
| `tracepoint/syscalls/sys_enter_sendmsg` | Handle `sendmsg`/`sendmmsg`, capture optional addresses |
| `tracepoint/syscalls/sys_enter_recvmsg` | Handle `recvmsg`, estimate the requested read length    |

All handlers reuse the utility function `update_traffic_stats()` to apply consistent accounting across multiple maps.

## Maps and Structures

### `struct traffic_key`
```c
struct traffic_key {
    __u32 pid;
    __u8  protocol;
    __u16 port;
    __u32 ip;
};
```
**Usage**: key for both `traffic_map` and `anomaly_map`, grouping traffic by PID + protocol + port + IP.

### Primary maps

| Map               | Type                     | Key/Value                           | Purpose                                              |
|-------------------|--------------------------|-------------------------------------|------------------------------------------------------|
| `traffic_map`     | `BPF_MAP_TYPE_HASH`      | `traffic_key` → `traffic_stats`     | Bytes/packets per logical connection                 |
| `protocol_totals` | `BPF_MAP_TYPE_HASH`      | `__u8` → `__u64`                    | Accumulated bytes per protocol                       |
| `pid_stats`       | `BPF_MAP_TYPE_HASH`      | `__u32` → `traffic_stats`           | Aggregate metrics per PID                            |
| `anomaly_map`     | `BPF_MAP_TYPE_HASH`      | `traffic_key` → `__u64`             | Channel to communicate high-bandwidth scores         |

### `struct traffic_stats`
```c
struct traffic_stats {
    __u64 bytes_sent;
    __u64 bytes_recv;
    __u64 packets_sent;
    __u64 packets_recv;
    __u64 last_update_ns;
};
```
**Notes**:
- `last_update_ns` stores the timestamp of the latest event, allowing user space to derive per-second throughput.
- Packet counters increment per syscall invocation (not per IP-layer packet).

## Syscall Argument Handling

### Extracting the PID
```c
__u64 pid_tgid = bpf_get_current_pid_tgid();
__u32 pid = pid_tgid >> 32;
if (pid == 0) return 0;
```
**Why**: avoid processing events without a valid PID.

### Decoding `sockaddr_in`
```c
void *addr_ptr = (void *)ctx->args[4];
if (addr_ptr) {
    __u16 family;
    if (bpf_probe_read_user(&family, sizeof(family), addr_ptr) == 0 && family == AF_INET) {
        struct sockaddr_in sin = {};
        if (bpf_probe_read_user(&sin, sizeof(sin), addr_ptr) == 0) {
            key.ip = sin.sin_addr.s_addr;
            key.port = ntohs(sin.sin_port);
        }
    }
}
```
**Key points**:
- Always guard reads.
- Ignore non-IPv4 addresses (IPv6 entries fall back to `ip = 0`).

### Reading `msghdr`
```c
void *msg_ptr = (void *)ctx->args[1];
if (msg_ptr) {
    struct msghdr *msg = (struct msghdr *)msg_ptr;
    __u64 count = BPF_CORE_READ(msg, msg_iter.count);
    bytes = count > 0 ? count : 1;
}
```
**Why `BPF_CORE_READ`?**
- Avoids hard-coded offsets that differ across kernel versions.
- Grants safe access to nested structures (`iov_iter.count`) without upsetting the verifier.

## Statistics Updates

### Utility function
```c
static void update_traffic_stats(struct traffic_key *key, __u64 bytes, bool is_sent);
```

**Steps performed**:
1. Increase `protocol_totals` by `bytes`.
2. Update or create an entry in `traffic_map`, accumulating bytes/packets and refreshing `last_update_ns`.
3. Update `pid_stats` to maintain per-PID aggregates.

**Design choice**: consolidating this logic avoids duplication across handlers and keeps counters consistent.

## Control Flow and Early Exits

Each handler performs quick checks to avoid unnecessary work:
- Invalid PID (`pid == 0`)
- Zero-length transfers (`bytes == 0` for `sendto`; default to 1 for `recv*` to mark activity)
- Failed user-space reads (silently ignored)

This pattern keeps the instruction count low and helps the program pass verifier checks.

## Safety Considerations

1. **Verifier** — Every pointer read is guarded, and failures terminate handling early.
2. **Memory** — Structs are zero-initialised before use (`struct traffic_key key = {};`).
3. **Return values** — Tracepoint handlers must return 0; all functions comply.

## Known Limitations

- **Address resolution**: `sendmsg` on connected TCP sockets often has `msg_name == NULL`, yielding zero IP/port.
- **Received bytes**: `recvfrom`/`recvmsg` work with the requested buffer size, not the actual return value. Monitoring `sys_exit` would be required for precise counts.
- **Other protocols**: Anything beyond TCP/UDP is labelled `PROTO_OTHER`; richer classification would need additional parsing.

## Potential Extensions

1. **IPv6 support** — Requires `sockaddr_in6` parsing and larger keys.
2. **Interface statistics** — Needs access to `struct socket` to determine outgoing interfaces.
3. **`sys_exit` hooks** — Would allow measuring actual bytes received.
4. **Per-CPU buffers** — Could cut contention under high event rates.

The Network Monitor eBPF program balances accuracy and simplicity, delivering reliable data to the ncurses frontend while staying within verifier constraints.

