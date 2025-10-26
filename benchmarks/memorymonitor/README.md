# Memory Monitor

A comprehensive real-time memory monitor that uses eBPF to track memory allocations and provides detailed process memory usage statistics. This implementation demonstrates advanced eBPF capabilities including multiple tracepoints, hash maps, ring buffers, and complex data structures.

## Features

- **Real-time monitoring**: Updates every 3 seconds with 100Hz UI refresh
- **Top 100 processes**: Shows processes with highest memory usage
- **eBPF integration**: Monitors memory allocation events (mmap, munmap, brk)
- **Hybrid data collection**: Combines eBPF allocation tracking with `/proc` real-time usage
- **Multiple metrics**: RSS, Virtual, Peak memory usage + allocation statistics
- **Interactive ncurses UI**: Scrollable interface with keyboard controls
- **Event streaming**: Ring buffer for high-throughput event processing
- **Memory leak detection**: Tracks allocation patterns and current usage

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
2. Attach to memory-related tracepoints (`sys_enter_mmap`, `sys_enter_munmap`, `sys_enter_brk`)
3. Monitor memory allocation events in real-time
4. Display the top 100 processes by memory usage

If you run without sudo, you'll see:
```
libbpf: Failed to bump RLIMIT_MEMLOCK
Failed to load BPF object: -1
```

## Output

Shows top 100 processes by memory usage with comprehensive statistics:
- **PID**: Process ID
- **NAME**: Process name (truncated to 20 chars)
- **RSS(KB)**: Current Resident Set Size in KB
- **VIRT(KB)**: Virtual memory usage in KB  
- **PEAK(KB)**: Peak RSS memory usage in KB
- **MMAP#**: Number of mmap operations (eBPF tracked)
- **MUNMAP#**: Number of munmap operations (eBPF tracked)

Example:
```
Memory Monitor - q: quit  ↑/↓: scroll
PID     NAME                 RSS(KB)     VIRT(KB)     PEAK(KB)    MMAP#   MUNMAP#
1234    firefox              251494      1048576      524288      45      12
5678    cursor               193741      876544       305152      23      8
9012    chrome               159949      410112       204800      67      34
```

## Controls

- **Ctrl+C or 'q'**: Quit the program
- **↑/↓ Arrow Keys**: Scroll through the process list
- **Auto-update**: Data collection refreshes every 3 seconds
- **UI refresh**: Interface updates at 100Hz for smooth interaction
- **Top 100**: Shows only the 100 processes using the most memory

## Architecture

This memory monitor uses a sophisticated hybrid approach:

### eBPF Kernel Program (`prog.bpf.c`)
- **3 Tracepoints**: `sys_enter_mmap`, `sys_enter_munmap`, `sys_enter_brk`
- **3 BPF Maps**: 
  - `mem_stats_map` (hash): Per-PID memory statistics
  - `active_allocs` (hash): Active allocation tracking
  - `mem_events` (ringbuf): High-throughput event streaming
- **Event Filtering**: Only tracks allocations ≥ 1KB to reduce noise
- **Real-time Processing**: Updates statistics synchronously with kernel events

### User-Space Program (`prog.c`)
- **Hybrid Data Collection**: Combines eBPF statistics with `/proc` real-time data
- **ncurses Interface**: Interactive terminal UI with scrolling
- **Process Discovery**: Scans `/proc` to find all running processes
- **Memory Parsing**: Reads RSS, Virtual, and Peak usage from `/proc/[pid]/status`
- **Performance Optimized**: Cached views, efficient sorting, decoupled I/O

## Use Cases

This memory monitor is particularly useful for:

- **Memory Leak Detection**: High allocation counts with low current usage may indicate leaks
- **Performance Analysis**: Identify processes with high memory allocation frequency  
- **Resource Monitoring**: Track memory usage patterns over time
- **System Optimization**: Identify memory-intensive processes for optimization
- **Development Debugging**: Monitor memory behavior during application development

## Documentation

Detailed technical documentation is available in the `explain/` folder:

- **`EBPF_IMPLEMENTATION.md`**: Explains the eBPF kernel program and how it tracks memory allocations
- **`USERSPACE_IMPLEMENTATION.md`**: Explains the user-space program and ncurses interface  
- **`SYSTEM_INTEGRATION.md`**: Explains how the eBPF and user-space programs work together
- **`MEMORY_MONITOR_COMPILER_REQUIREMENTS.md`**: Outlines specific compiler enhancements needed to implement this memory monitor in Elixir using Honey Potion

## Elixir Implementation

This memory monitor demonstrates the capabilities needed for eBPF-based memory monitoring. The `MEMORY_MONITOR_COMPILER_REQUIREMENTS.md` document outlines the specific enhancements required for the Honey Potion compiler to enable creating equivalent functionality in Elixir.

**Key Features Demonstrated**:
- Multiple tracepoint handlers (mmap, munmap, brk)
- Hash maps with custom data structures
- Ring buffer for event streaming
- Complex data structures with string fields
- Real-time memory usage tracking

**Current Status**: The C implementation is fully functional. The Elixir implementation requires compiler enhancements as outlined in the requirements document.
