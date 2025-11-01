# CPU Monitor - eBPF Implementation

## Overview

This document explains the eBPF implementation that collects CPU usage data at the kernel level. The eBPF program uses tracepoints to monitor process scheduling and system call activity, providing real-time CPU usage metrics.

## Architecture Overview

### Why eBPF?

1. **Kernel-Level Access**: Direct access to kernel data structures without system calls
2. **Low Overhead**: Minimal performance impact on the system being monitored
3. **Safety**: eBPF programs are verified by the kernel before execution
4. **Real-Time**: Data collection happens synchronously with kernel events

### Tracepoint Strategy

The implementation uses three tracepoints to capture different aspects of CPU usage:

1. **`sched:sched_switch`**: Tracks when processes are scheduled on/off CPU
2. **`raw_syscalls:sys_enter`**: Captures when processes enter system calls
3. **`raw_syscalls:sys_exit`**: Captures when processes exit system calls

## Data Structures

### BPF Maps

#### `start_time` Map
```c
struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 10240);
    __type(key, u32);      // PID
    __type(value, u64);    // Timestamp when process started running
} start_time SEC(".maps");
```

**Purpose**: Tracks when each process starts running on a CPU.

**Design Decisions**:
- **Hash Map**: O(1) lookup time for active processes
- **10,240 Entries**: Supports monitoring up to 10K concurrent processes
- **u32 Key**: PID (32-bit unsigned integer)
- **u64 Value**: Nanosecond timestamp from `bpf_ktime_get_ns()`

#### `kernel_time` Map
```c
struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 10240);
    __type(key, u32);      // PID
    __type(value, u64);    // Cumulative kernel time in nanoseconds
} kernel_time SEC(".maps");
```

**Purpose**: Stores cumulative time spent in kernel space for each process.

#### `user_time` Map
```c
struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 10240);
    __type(key, u32);      // PID
    __type(value, u64);    // Cumulative user time in nanoseconds
} user_time SEC(".maps");
```

**Purpose**: Stores cumulative time spent in user space for each process.

#### `syscall_start` Map
```c
struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 10240);
    __type(key, u32);      // PID
    __type(value, u64);    // Timestamp when syscall started
} syscall_start SEC(".maps");
```

**Purpose**: Tracks when each process enters a system call.

#### `run_kernel_time` Map
```c
struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 10240);
    __type(key, u32);      // PID
    __type(value, u64);    // Kernel time for current CPU run
} run_kernel_time SEC(".maps");
```

**Purpose**: Temporarily stores kernel time accumulated during a single CPU run.

## Tracepoint Handlers

### `on_sched_switch` - Process Scheduling Handler

```c
SEC("tracepoint/sched/sched_switch")
int on_sched_switch(struct trace_event_raw_sched_switch *ctx) {
    u64 ts = bpf_ktime_get_ns();
    u32 prev_pid = ctx->prev_pid;
    u32 next_pid = ctx->next_pid;
    
    // Process previous process
    // Start timing next process
}
```

#### Context Structure
- **`ctx->prev_pid`**: PID of the process being switched out
- **`ctx->next_pid`**: PID of the process being switched in
- **`ts`**: Current timestamp in nanoseconds

#### Algorithm Logic

1. **Process Previous Process**:
   ```c
   u64 *start = bpf_map_lookup_elem(&start_time, &prev_pid);
   if (start) {
       u64 delta = ts - *start;
       // Calculate user time = total time - kernel time
       // Update cumulative times
       bpf_map_delete_elem(&start_time, &prev_pid);
   }
   ```

2. **Start Timing Next Process**:
   ```c
   bpf_map_update_elem(&start_time, &next_pid, &ts, BPF_ANY);
   ```

#### Time Calculation Logic

**User Time Calculation**:
```c
u64 ktime = 0;
u64 *kstart = bpf_map_lookup_elem(&run_kernel_time, &prev_pid);
if (kstart) {
    ktime = *kstart;
    bpf_map_delete_elem(&run_kernel_time, &prev_pid);
}

if (ktime < delta) {
    u64 utime = delta - ktime;
    // Update user_time map
}
```

**Why This Approach**:
- **Total Time**: `delta = current_time - start_time`
- **Kernel Time**: Accumulated during system calls
- **User Time**: `total_time - kernel_time`
- **Cleanup**: Removes temporary kernel time tracking

### `on_sys_enter` - System Call Entry Handler

```c
SEC("tracepoint/raw_syscalls/sys_enter")
int on_sys_enter(struct trace_event_raw_sys_enter *ctx) {
    u32 pid = bpf_get_current_pid_tgid() >> 32;
    u64 ts = bpf_ktime_get_ns();
    bpf_map_update_elem(&syscall_start, &pid, &ts, BPF_ANY);
    return 0;
}
```

#### Key Functions
- **`bpf_get_current_pid_tgid()`**: Returns `(tgid << 32) | pid`
- **`>> 32`**: Extracts the thread group ID (process ID)
- **`BPF_ANY`**: Update map entry regardless of existing value

#### Purpose
- Records when a process enters a system call
- Used to calculate kernel time spent in system calls

### `on_sys_exit` - System Call Exit Handler

```c
SEC("tracepoint/raw_syscalls/sys_exit")
int on_sys_exit(struct trace_event_raw_sys_exit *ctx) {
    u32 pid = bpf_get_current_pid_tgid() >> 32;
    u64 ts = bpf_ktime_get_ns();
    u64 *start = bpf_map_lookup_elem(&syscall_start, &pid);
    if (start) {
        u64 delta = ts - *start;
        // Update run_kernel_time
        bpf_map_delete_elem(&syscall_start, &pid);
    }
    return 0;
}
```

#### Algorithm
1. **Get Entry Time**: Look up when the syscall started
2. **Calculate Duration**: `delta = exit_time - entry_time`
3. **Accumulate**: Add to `run_kernel_time` for this process
4. **Cleanup**: Remove the entry time record

## Data Flow Architecture

### Process Lifecycle Tracking

```
Process Start → sched_switch (next_pid) → start_time[pid] = timestamp
Process Running → sys_enter → syscall_start[pid] = timestamp
Process in Syscall → sys_exit → run_kernel_time[pid] += duration
Process End → sched_switch (prev_pid) → Calculate total times
```

### Time Accumulation Strategy

#### Kernel Time
- **Accumulated**: During system call execution
- **Stored**: In `run_kernel_time` during CPU run
- **Finalized**: When process is switched out

#### User Time
- **Calculated**: `total_time - kernel_time`
- **Reasoning**: Time not spent in system calls is user time
- **Updated**: When process is switched out

#### Total Time
- **Calculated**: `current_time - start_time`
- **Represents**: Total CPU time for the run
- **Includes**: Both user and kernel time

## Memory Management

### Map Operations

#### Lookup Operations
```c
u64 *value = bpf_map_lookup_elem(&map, &key);
if (value) {
    // Use value
}
```

**Error Handling**: Always check for NULL return values.

#### Update Operations
```c
bpf_map_update_elem(&map, &key, &value, BPF_ANY);
```

**Flags**:
- **`BPF_ANY`**: Create or update
- **`BPF_NOEXIST`**: Only create if doesn't exist
- **`BPF_EXIST`**: Only update if exists

#### Delete Operations
```c
bpf_map_delete_elem(&map, &key);
```

**Cleanup**: Removes entries when processes exit or complete operations.

### Memory Efficiency

#### Temporary Storage
- **`syscall_start`**: Short-lived entries, cleaned up immediately
- **`run_kernel_time`**: Per-CPU-run storage, cleaned up on context switch
- **`start_time`**: Active process tracking, cleaned up on context switch

#### Persistent Storage
- **`kernel_time`**: Cumulative data, persists across context switches
- **`user_time`**: Cumulative data, persists across context switches

## Performance Considerations

### eBPF Limitations

#### Instruction Limits
- **Complexity**: eBPF programs have instruction count limits
- **Loops**: No unbounded loops allowed
- **Function Calls**: Limited to helper functions

#### Memory Access
- **Bounds Checking**: All memory access is verified
- **Stack Size**: Limited stack space (512 bytes)
- **Map Access**: Only through helper functions

### Optimization Strategies

#### Efficient Map Operations
- **Minimal Lookups**: Cache frequently accessed values
- **Batch Updates**: Group related operations
- **Early Returns**: Exit quickly on error conditions

#### Data Structure Design
- **Fixed Size**: All map values are fixed-size (u64)
- **Simple Keys**: Use PIDs as simple integer keys
- **Minimal State**: Store only necessary data

## Error Handling

### Map Operation Failures
```c
u64 *value = bpf_map_lookup_elem(&map, &key);
if (!value) {
    // Handle lookup failure
    return 0;
}
```

### Graceful Degradation
- **Continue Operation**: Don't fail entire program on single map error
- **Log Errors**: Use `bpf_printk()` for debugging (if available)
- **Return Codes**: Return appropriate error codes

## Security Considerations

### eBPF Safety
- **Verification**: Kernel verifies program safety before execution
- **Sandboxing**: eBPF programs run in isolated environment
- **Resource Limits**: CPU and memory usage are limited

### Data Privacy
- **PID Only**: Only collects process IDs, not sensitive data
- **Timing Data**: Only collects timing information
- **No Content**: Doesn't access process memory or file contents

## Compilation and Loading

### Compilation Process
```bash
clang -S -target bpf -D__BPF_TRACING__ -D__TARGET_ARCH_x86 \
      -O2 -emit-llvm -c -g prog.bpf.c -o prog.bpf.ll
llc -march=bpf -filetype=obj -o prog.bpf.o prog.bpf.ll
```

### Key Compiler Flags
- **`-target bpf`**: Compile for eBPF target
- **`-D__BPF_TRACING__`**: Enable tracing-specific features
- **`-D__TARGET_ARCH_x86`**: Target x86 architecture
- **`-O2`**: Optimize for performance
- **`-g`**: Include debug information

### Loading Process
1. **Object Loading**: Load compiled eBPF object
2. **Program Attachment**: Attach programs to tracepoints
3. **Map Access**: Get file descriptors for maps
4. **Data Collection**: Start collecting data

## Interaction with User-Space Code

### Data Flow
1. **eBPF Program**: Collects raw timing data
2. **BPF Maps**: Store cumulative values
3. **User-Space**: Reads maps and calculates percentages
4. **Display**: Shows processed data to user

### Map Access
```c
int kernel_fd = get_map_fd_by_name(obj, "kernel_time");
int user_fd = get_map_fd_by_name(obj, "user_time");
```

### Data Interpretation
- **Raw Values**: eBPF provides nanosecond timestamps
- **Processing**: User-space converts to percentages
- **Display**: Formatted for human consumption

### Synchronization
- **No Locks**: eBPF maps are lock-free
- **Atomic Updates**: Map operations are atomic
- **Consistent Reads**: User-space sees consistent snapshots

## Debugging and Troubleshooting

### Common Issues
1. **Map Lookup Failures**: Check if process exists
2. **Memory Limits**: Monitor map usage
3. **Verification Failures**: Check eBPF program complexity

### Debugging Tools
- **`bpftool`**: Inspect loaded programs and maps
- **`bpf_printk()`**: Print debug information (if available)
- **Kernel Logs**: Check for eBPF-related errors

### Performance Monitoring
- **Map Usage**: Monitor map entry counts
- **Program Execution**: Check for program failures
- **System Impact**: Monitor overall system performance

## Future Enhancements

### Additional Metrics
1. **Memory Usage**: Track process memory consumption
2. **I/O Statistics**: Monitor disk and network I/O
3. **Thread Information**: Track per-thread CPU usage

### Performance Improvements
1. **Per-CPU Maps**: Use per-CPU maps for better performance
2. **Ring Buffers**: Use ring buffers for high-frequency events
3. **Aggregation**: Aggregate data in kernel space

### Feature Additions
1. **Process Filtering**: Filter processes by criteria
2. **Historical Data**: Store historical CPU usage
3. **Alerts**: Trigger alerts on high CPU usage

## Conclusion

The design prioritizes performance and accuracy while maintaining system stability and security. The separation of concerns between eBPF data collection and user-space processing allows for a responsive, real-time monitoring solution.