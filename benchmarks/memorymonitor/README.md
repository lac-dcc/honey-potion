# Memory Monitor

A real-time memory monitor that uses eBPF to track memory allocations and shows processes sorted by memory usage.

## Features

- **Real-time monitoring**: Updates every 3 seconds
- **Top 100 processes**: Shows processes with highest memory usage
- **eBPF integration**: Monitors memory allocation events (mmap, munmap, brk)
- **Multiple metrics**: RSS, Virtual, and Peak memory usage
- **Interactive**: Runs continuously until Ctrl+C

## Requirements

- Root privileges (for eBPF attachment)
- libbpf, libelf, zlib development libraries

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
2. Attach to memory-related tracepoints (`sys_enter_mmap`, `sys_enter_munmap`, `sys_enter_brk`)
3. Monitor memory allocation events in real-time
4. Display the top 100 processes by memory usage

If you run without sudo, you'll see:
```
libbpf: Failed to bump RLIMIT_MEMLOCK
Failed to load BPF object: -1
```

## Output

Shows top 100 processes by memory usage:
- PID
- Process name  
- RSS (Resident Set Size) in MB
- Virtual memory in MB
- Peak memory usage in MB

Example:
```
Memory Monitor - Press Ctrl+C or 'q' to quit | Top 100 processes | Updates every 3s
================================================================================
PID	NAME			RSS(MB)	VIRT(MB)	PEAK(MB)
================================================================================
1234	firefox		245.6	1024.0		512.3
5678	cursor		189.2	856.4		298.7
9012	chrome		156.2	400.5		200.1
```

## Controls

- **Ctrl+C**: Quit the program
- **Auto-update**: Refreshes every 3 seconds
- **Top 100**: Shows only the 100 processes using the most memory

## Documentation

Detailed technical documentation is available in the `explain/` folder:

- **`EBPF_IMPLEMENTATION.md`**: Explains the eBPF kernel program and how it tracks memory allocations
- **`USERSPACE_IMPLEMENTATION.md`**: Explains the user-space program and ncurses interface
- **`SYSTEM_INTEGRATION.md`**: Explains how the eBPF and user-space programs work together
