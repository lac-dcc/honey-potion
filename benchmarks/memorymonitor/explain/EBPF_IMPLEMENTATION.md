# Memory Monitor - eBPF Implementation

## Overview

This document explains the eBPF implementation that collects memory allocation data at the kernel level. The eBPF program uses tracepoints to monitor memory allocation system calls, providing real-time memory usage metrics and tracking memory allocation patterns.

## Architecture Overview

### Why eBPF?

1. **Kernel-Level Access**: Direct access to memory allocation system calls without user-space overhead
2. **Low Overhead**: Minimal performance impact on the system being monitored
3. **Safety**: eBPF programs are verified by the kernel before execution
4. **Real-Time**: Data collection happens synchronously with kernel events
5. **Comprehensive Tracking**: Captures all memory allocation events system-wide

### Tracepoint Strategy

The implementation uses three tracepoints to capture different aspects of memory management:

1. **`syscalls:sys_enter_mmap`**: Tracks memory mapping operations (file-backed and anonymous)
2. **`syscalls:sys_enter_munmap`**: Tracks memory unmapping operations
3. **`syscalls:sys_enter_brk`**: Tracks heap management operations

## Data Structures

### BPF Maps

#### `mem_stats_map` Map
```c
struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 10240);
    __type(key, u32);
    __type(value, struct mem_stats);
} mem_stats_map SEC(".maps");
```

**Purpose**: Stores per-process memory allocation statistics
- **Key**: Process ID (PID)
- **Value**: Memory statistics structure
- **Size**: Up to 10,240 processes tracked simultaneously

#### `mem_events` Ring Buffer
```c
struct {
    __uint(type, BPF_MAP_TYPE_RINGBUF);
    __uint(max_entries, 256 * 1024);
} mem_events SEC(".maps");
```

**Purpose**: Streams memory allocation events to user-space
- **Type**: Ring buffer for high-throughput event streaming
- **Size**: 256KB buffer for event queuing
- **Usage**: Real-time event notification to user-space program

#### `active_allocs` Map
```c
struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 10240);
    __type(key, u64);
    __type(value, u64);
} active_allocs SEC(".maps");
```

**Purpose**: Tracks active allocations for leak detection
- **Key**: Memory address of allocation
- **Value**: Size of allocation
- **Usage**: Enables memory leak detection and fragmentation analysis

### Data Structures

#### `struct mem_stats`
```c
struct mem_stats {
    u64 total_allocated;    // Total bytes allocated by process
    u64 total_freed;        // Total bytes freed by process
    u64 current_usage;      // Current memory usage (allocated - freed)
    u64 peak_usage;         // Peak memory usage reached
    u64 alloc_count;        // Number of allocation operations
    u64 free_count;         // Number of deallocation operations
    u64 mmap_count;         // Number of mmap operations
    u64 munmap_count;       // Number of munmap operations
    u64 last_update;        // Timestamp of last update
};
```

#### `struct mem_event`
```c
struct mem_event {
    u64 timestamp;          // Event timestamp (nanoseconds)
    u32 pid;                // Process ID
    u32 tgid;               // Thread Group ID
    u64 size;               // Size of allocation/deallocation
    u64 address;            // Memory address (for specific allocations)
    u8 event_type;          // 0=alloc, 1=free, 2=mmap, 3=munmap, 4=brk
    char comm[16];          // Process name
};
```

## eBPF Functions

### Core Helper Functions

#### `get_current_pid()` and `get_current_tgid()`
```c
static inline u32 get_current_pid(void) {
    return bpf_get_current_pid_tgid() & 0xFFFFFFFF;
}

static inline u32 get_current_tgid(void) {
    return bpf_get_current_pid_tgid() >> 32;
}
```

**Purpose**: Extract process and thread group IDs from the current context
**Usage**: Identifies which process is performing memory operations

#### `update_mem_stats()`
```c
static inline void update_mem_stats(u32 pid, u64 size, u8 event_type) {
    // Updates mem_stats_map with new allocation/deallocation data
    // Handles different event types: alloc, free, mmap, munmap
}
```

**Purpose**: Centralized function to update memory statistics
**Parameters**:
- `pid`: Process ID
- `size`: Size of memory operation
- `event_type`: Type of operation (0=alloc, 1=free, 2=mmap, 3=munmap)

### Tracepoint Handlers

#### `trace_mmap_enter()`
```c
SEC("tracepoint/syscalls/sys_enter_mmap")
int trace_mmap_enter(struct trace_event_raw_sys_enter *ctx) {
    u32 pid = get_current_pid();
    u32 tgid = get_current_tgid();
    u64 length = ctx->args[1]; // length parameter
    
    // Only track significant allocations (>= 1KB)
    if (length >= 1024) {
        update_mem_stats(pid, length, 2);
        // Send event to ring buffer
    }
    return 0;
}
```

**Purpose**: Monitors memory mapping operations
**Key Features**:
- Filters out small allocations (< 1KB) to reduce noise
- Tracks both file-backed and anonymous memory mappings
- Sends events to ring buffer for real-time monitoring

#### `trace_munmap_enter()`
```c
SEC("tracepoint/syscalls/sys_enter_munmap")
int trace_munmap_enter(struct trace_event_raw_sys_enter *ctx) {
    u32 pid = get_current_pid();
    u32 tgid = get_current_tgid();
    u64 length = ctx->args[1]; // length parameter
    
    update_mem_stats(pid, length, 3);
    // Send event to ring buffer
    return 0;
}
```

**Purpose**: Monitors memory unmapping operations
**Key Features**:
- Tracks when processes release mapped memory
- Updates statistics for memory deallocation
- Enables tracking of memory usage patterns

#### `trace_brk_enter()`
```c
SEC("tracepoint/syscalls/sys_enter_brk")
int trace_brk_enter(struct trace_event_raw_sys_enter *ctx) {
    u32 pid = get_current_pid();
    u32 tgid = get_current_tgid();
    u64 addr = ctx->args[0];
    
    // Send event to ring buffer
    return 0;
}
```

**Purpose**: Monitors heap management operations
**Key Features**:
- Tracks heap expansion/contraction via brk() system call
- Provides insight into heap usage patterns
- Enables detection of heap fragmentation

## Integration with User-Space

### Data Flow

1. **Kernel Events**: Memory allocation system calls trigger eBPF tracepoints
2. **eBPF Processing**: Tracepoint handlers update maps and send events
3. **User-Space Reading**: User-space program reads from BPF maps every 3 seconds
4. **Real-Time Display**: Memory statistics displayed in ncurses interface

### Map Access Pattern

```c
// User-space reads statistics
bpf_map_lookup_elem(mem_stats_fd, &key, &stats);

// User-space reads events (if using ring buffer)
bpf_ringbuf_consume(ringbuf_fd, event_callback, NULL);
```

### Performance Considerations

1. **Filtering**: Only tracks allocations >= 1KB to reduce overhead
2. **Batch Updates**: Statistics updated in batches, not per-event
3. **Map Size**: Limited to 10,240 processes to control memory usage
4. **Ring Buffer**: 256KB buffer provides good throughput for events

## Benefits of This Approach

1. **Comprehensive Coverage**: Captures all memory allocation types
2. **Real-Time Data**: Immediate visibility into memory usage patterns
3. **Low Overhead**: Minimal impact on system performance
4. **Leak Detection**: Enables identification of memory leaks
5. **Fragmentation Analysis**: Provides data for memory fragmentation analysis
6. **Process Tracking**: Per-process memory allocation statistics

## Limitations

1. **Kernel Space Only**: Cannot track user-space only allocations
2. **System Call Level**: Some memory operations may not go through tracked syscalls
3. **Address Space**: Cannot track memory usage within process address space
4. **Shared Memory**: Complex shared memory scenarios may not be fully captured