# Disk Monitor

A comprehensive real-time disk I/O monitor that uses eBPF to track disk operations, measure I/O latency, and provide detailed statistics per process and operation type. This implementation demonstrates advanced eBPF capabilities including multiple tracepoints, hash maps, and latency measurement.

## Features

- **Real-time monitoring**: Updates every second with 100Hz UI refresh
- **Top 50 processes**: Shows processes with highest I/O activity
- **eBPF integration**: Monitors disk I/O syscalls (read, write, pread64, pwrite64, readv, writev)
- **Latency tracking**: Measures and displays average, min, and max I/O latency
- **Multiple metrics**: Bytes read/written, I/O rate, operation count, latency statistics
- **Interactive ncurses UI**: Scrollable interface with keyboard controls
- **Anomaly detection**: Highlights processes with high I/O rates (>10 MB/s)

## Requirements

- Root privileges (for eBPF attachment)
- libbpf, libelf, zlib, ncurses development libraries
- Linux kernel with eBPF support
- BTF (BPF Type Format) support in kernel

## Build

```bash
make
```

## Run

```bash
sudo ./prog
```

**Note**: This program requires root privileges because eBPF programs need to be loaded into the kernel. The program will:
1. Load the eBPF program (`prog.bpf.o`) into the kernel
2. Attach to disk I/O tracepoints (`sys_enter_read`, `sys_exit_read`, `sys_enter_write`, `sys_exit_write`, etc.)
3. Monitor disk I/O operations in real-time
4. Display the top 50 processes by I/O activity

If you run without sudo, you'll see:
```
libbpf: Failed to bump RLIMIT_MEMLOCK
Failed to load BPF object: -1
```

## Output

Shows top 50 processes by I/O activity with comprehensive statistics:
- **PID**: Process ID
- **PROCESS**: Process name (truncated to 20 chars)
- **OP**: Operation type (READ or WRITE)
- **READ**: Total bytes read
- **WRITE**: Total bytes written
- **IO RATE**: Current I/O rate (bytes/second) with EMA smoothing
- **OPS**: Total number of I/O operations
- **AVG LAT**: Average latency per operation

Example:
```
Disk Monitor - q: quit  ↑/↓: scroll
PID     PROCESS             OP      READ        WRITE       IO RATE         OPS         AVG LAT
1234    firefox             READ    251.49 MB   12.34 MB    5.23 MB/s       1234        1.23 ms
5678    cursor              WRITE   45.67 MB    89.12 MB    2.45 MB/s       567         0.89 ms
9012    dd                  READ    1.23 GB     0.00 B      50.12 MB/s      8901        0.45 ms
```

## Controls

- **Ctrl+C or 'q'**: Quit the program
- **↑/↓ Arrow Keys**: Scroll through the process list
- **Page Up/Page Down**: Scroll by page
- **Auto-update**: Data collection refreshes every second
- **UI refresh**: Interface updates at 100Hz for smooth interaction
- **Top 50**: Shows only the 50 processes with highest I/O activity

## Architecture

This disk monitor uses a sophisticated approach to track I/O operations:

### eBPF Kernel Program (`prog.bpf.c`)
- **10 Tracepoints**: 
  - `sys_enter_read` / `sys_exit_read`
  - `sys_enter_write` / `sys_exit_write`
  - `sys_enter_pread64` / `sys_exit_pread64`
  - `sys_enter_pwrite64` / `sys_exit_pwrite64`
  - `sys_enter_readv` / `sys_exit_readv`
  - `sys_enter_writev` / `sys_exit_writev`
- **3 BPF Maps**: 
  - `io_stats_map` (hash): Per-PID and operation type statistics
  - `io_start_time` (hash): Temporary storage for latency measurement
  - `pid_stats` (hash): Aggregated per-PID statistics
- **Latency Measurement**: Tracks time between sys_enter and sys_exit
- **Real-time Processing**: Updates statistics synchronously with kernel events

### User-Space Program (`prog.c`)
- **ncurses Interface**: Interactive terminal UI with scrolling
- **EMA Smoothing**: Exponential Moving Average for I/O rate calculation (alpha = 0.3)
- **Process Discovery**: Reads process names from `/proc/[pid]/comm`
- **Performance Optimized**: Cached views, efficient sorting, decoupled I/O
- **Anomaly Detection**: Highlights processes with I/O rates > 10 MB/s

## Use Cases

This disk monitor is particularly useful for:

- **Performance Analysis**: Identify processes with high disk I/O activity
- **Latency Monitoring**: Track I/O latency patterns to detect slow storage
- **Resource Monitoring**: Monitor disk usage patterns over time
- **System Optimization**: Identify I/O-intensive processes for optimization
- **Development Debugging**: Monitor disk I/O behavior during application development
- **Storage Troubleshooting**: Detect processes causing excessive disk I/O

## Monitored Syscalls

The monitor tracks the following disk I/O syscalls:

- **read** (0): Standard read operation
- **write** (1): Standard write operation
- **pread64** (17): Positional read at specific offset
- **pwrite64** (18): Positional write at specific offset
- **readv** (19): Vector read (scatter-gather)
- **writev** (20): Vector write (scatter-gather)

Note: The monitor tracks all I/O operations, not just those targeting disk devices. This includes file I/O, which is the most common form of disk I/O in user applications.

## Latency Measurement

The monitor measures I/O latency by:
1. Recording timestamp on `sys_enter_*` tracepoint
2. Recording timestamp on `sys_exit_*` tracepoint
3. Calculating delta to get operation latency
4. Aggregating statistics (total, min, max, average)

This provides accurate latency measurements for each I/O operation, helping identify slow storage or I/O bottlenecks.

## Documentation

Detailed technical documentation is available in the `explain/` folder (to be added):

- **`EBPF_IMPLEMENTATION.md`**: Explains the eBPF kernel program and how it tracks disk I/O
- **`USERSPACE_IMPLEMENTATION.md`**: Explains the user-space program and ncurses interface  
- **`SYSTEM_INTEGRATION.md`**: Explains how the eBPF and user-space programs work together

## Elixir Implementation

This disk monitor demonstrates the capabilities needed for eBPF-based disk I/O monitoring. Future enhancements could include:

- File-level tracking (mapping file descriptors to file paths)
- Device-level aggregation (tracking I/O per disk device)
- Block-level statistics (tracking I/O at the block device level)
- I/O pattern analysis (sequential vs random I/O detection)

**Current Status**: The C implementation is fully functional and ready for use.

