# 🌐 Network Monitor - eBPF Network Traffic Analysis

This eBPF benchmark monitors network traffic in real-time, classifying packets by protocol and application, measuring bandwidth usage, and detecting anomalies such as excessive traffic or suspicious network activity.

## Overview

The Network Monitor uses eBPF tracepoints to capture network activity at the kernel level, providing:

- **Protocol Classification**: Identifies TCP, UDP, ICMP, and other protocols
- **Application Detection**: Maps traffic to applications based on port numbers
- **Bandwidth Measurement**: Calculates real-time bandwidth usage per process and connection
- **Anomaly Detection**: Identifies unusual network patterns (excessive traffic, high bandwidth connections)

## Architecture

### eBPF Backend (`prog.bpf.c`)

The eBPF program uses multiple tracepoints to capture network activity:

1. **`syscalls/sys_enter_sendto`**: Captures outgoing sendto socket operations
2. **`syscalls/sys_enter_recvfrom`**: Captures incoming recvfrom socket operations
3. **`syscalls/sys_enter_sendmsg`**: Captures outgoing sendmsg socket operations
4. **`syscalls/sys_enter_recvmsg`**: Captures incoming recvmsg socket operations

#### BPF Maps

- **`traffic_map`**: Stores traffic statistics keyed by PID, protocol, port, and IP
- **`protocol_totals`**: Aggregates total bytes per protocol
- **`pid_stats`**: Per-process network statistics
- **`anomaly_map`**: Tracks high-bandwidth connections for anomaly detection

### Userspace Frontend (`prog.c`)

The userspace program:
- Loads and attaches the eBPF program to tracepoints
- Reads statistics from BPF maps
- Displays real-time network statistics
- Calculates bandwidth and detects anomalies
- Formats output in a human-readable format

## Features

### 1. Protocol Statistics
Shows total bytes transferred per protocol (TCP, UDP, ICMP, etc.)

### 2. Top Traffic by PID
Lists processes using the most network bandwidth, sorted by total traffic

### 3. Traffic Classification
Groups traffic by:
- Protocol (TCP/UDP/ICMP)
- Port number
- Application name (based on common ports)

### 4. Anomaly Detection
Monitors for:
- High bandwidth connections (>10 MB/s threshold)
- Excessive traffic patterns
- Suspicious network activity

## Requirements

- Linux kernel 5.8+ (for BTF support)
- libbpf development libraries
- clang/llvm for BPF compilation
- bpftool for BTF and skeleton generation

Install on Ubuntu/Debian:
```bash
sudo apt update
sudo apt install -y clang llvm make pkg-config libbpf-dev libelf-dev zlib1g-dev
```

## Build

From this directory:
```bash
make
```

This produces:
- `prog`          (user-space loader + monitoring)
- `prog.bpf.o`    (compiled eBPF object)
- `prog.bpf.ll`   (LLVM IR)
- `prog.skel.h`   (libbpf skeleton)
- `vmlinux.h`     (kernel BTF dump)

## Run

```bash
sudo ./prog
```

The program will:
1. Load the eBPF program into the kernel
2. Attach to network tracepoints
3. Display real-time network statistics every 1 second
4. Show protocol statistics, top processes, and anomaly alerts

Press `Ctrl+C` to exit.

## Example Output

```
=== Network Monitor - Real-time Traffic Analysis ===

--- Protocol Statistics ---
Protocol   Total Bytes
----------------------------------------
TCP                15.2 MB
UDP                 2.1 MB
ICMP                0.1 MB

--- Top Traffic by PID ---
PID    Process              Sent (B)      Recv (B)    Total (B)    Bandwidth
----------------------------------------------------------------------------
1234   firefox              5.2 MB        12.1 MB     17.3 MB      2.1 MB/s
5678   chrome               3.8 MB        8.9 MB      12.7 MB      1.5 MB/s

--- Traffic by Protocol and Port ---
Protocol Port   Application      Sent      Recv      Total
----------------------------------------------------------------------------
TCP      443    HTTPS           8.2 MB    15.1 MB   23.3 MB
TCP      80     HTTP            1.5 MB    3.2 MB    4.7 MB
UDP      53     DNS             0.1 MB    0.2 MB    0.3 MB

--- Anomaly Detection ---
Monitoring for excessive traffic...
(Threshold: > 10 MB/s per connection)
✓ No anomalies detected
```

## Troubleshooting

### Permission Denied
- Run with `sudo` - eBPF programs require root privileges
- Ensure kernel supports eBPF (check `/sys/kernel/btf/vmlinux`)

### Tracepoint Attach Failures
- Some tracepoints may not be available on all kernel versions
- The program will continue with available tracepoints
- Check kernel version: `uname -r` (requires 5.8+)

### No Data Appearing
- Wait a few seconds for traffic to accumulate
- Generate some network activity (browse web, ping, etc.)
- Check if tracepoints are attached: `sudo bpftool prog list`

### BTF Not Available
- Ensure kernel was compiled with `CONFIG_DEBUG_INFO_BTF=y`
- On some distributions, install kernel debug packages
- Alternative: use a kernel with built-in BTF support

## Technical Details

### Tracepoint Strategy

The program uses multiple tracepoints for comprehensive coverage:

1. **Socket Tracepoints**: Capture socket-level operations
   - More reliable for process-level tracking
   - Provides PID information
   - May miss some low-level packets

2. **SKB Tracepoints**: Capture packet-level events
   - More accurate packet counting
   - Better for protocol analysis
   - May have limited PID information

### Data Structures

#### Traffic Key
```c
struct traffic_key {
    __u32 pid;      // Process ID
    __u8 protocol;  // IP protocol number
    __u16 port;     // Destination port
    __u32 ip;       // Destination IP address
};
```

#### Traffic Statistics
```c
struct traffic_stats {
    __u64 bytes_sent;      // Bytes sent
    __u64 bytes_recv;      // Bytes received
    __u64 packets_sent;    // Packets sent
    __u64 packets_recv;    // Packets received
    __u64 last_update_ns;  // Last update timestamp
};
```

### Anomaly Detection Algorithm

1. Calculate bandwidth per connection: `bytes / time_elapsed`
2. Compare against threshold (default: 10 MB/s)
3. Alert if bandwidth exceeds threshold
4. Track persistent high-bandwidth connections

### Performance Considerations

- **Low Overhead**: eBPF programs run in kernel with minimal overhead
- **Efficient Maps**: Hash maps provide O(1) lookup performance
- **Bounded Memory**: Maps have fixed maximum entries (prevents memory exhaustion)
- **Real-time Updates**: Statistics updated in kernel, read periodically by userspace

## Limitations

1. **IPv4 Only**: Currently tracks IPv4 traffic only (IPv6 support can be added)
2. **Port-Based Classification**: Application detection based on common ports (may misclassify)
3. **Tracepoint Availability**: Some tracepoints may not be available on older kernels
4. **PID Tracking**: May not capture all network activity (depends on tracepoint availability)

## Future Enhancements

1. **IPv6 Support**: Add IPv6 address tracking
2. **Deep Packet Inspection**: Analyze packet contents for better classification
3. **Historical Tracking**: Store historical data for trend analysis
4. **Configurable Thresholds**: Allow users to set anomaly detection thresholds
5. **Export Functionality**: Export statistics to files for analysis
6. **Interactive UI**: Add ncurses-based interactive interface (like cpumonitor)

## References

- [eBPF Documentation](https://ebpf.io/what-is-ebpf/)
- [libbpf Documentation](https://libbpf.readthedocs.io/)
- [BPF Tracepoints](https://www.kernel.org/doc/html/latest/trace/tracepoints.html)
- [Network Monitoring with eBPF](https://github.com/iovisor/bcc)

## License

This benchmark follows the same license as the Honey Potion project.

