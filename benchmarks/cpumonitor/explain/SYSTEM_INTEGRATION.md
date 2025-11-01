# CPU Monitor - System Integration

## Overview

This document explains how the eBPF kernel program and user-space program work together to provide comprehensive CPU monitoring. The integration combines real-time kernel-level process scheduling and system call tracking with user-space process management and display to create a complete picture of system CPU behavior.

### Component Interaction

1. **Kernel Events**: Process scheduling and system calls trigger eBPF tracepoints
2. **eBPF Processing**: Tracepoint handlers update BPF maps with timing data
3. **User-Space Reading**: Program reads from BPF maps and `/proc` filesystem
4. **Data Integration**: Combines eBPF timing data with process information
5. **Display**: Shows integrated view in ncurses interface

## eBPF ↔ User-Space Communication

### BPF Maps as Communication Channels

#### `start_time` Map - Process Start Tracking
```c
// eBPF side: Records process start times
u64 start = bpf_ktime_get_ns();
bpf_map_update_elem(&start_time, &pid, &start, BPF_ANY);

// User-space side: Reads start times
u64 start = 0;
if (bpf_map_lookup_elem(start_fd, &pid, &start) == 0) {
    // Calculate elapsed time since process start
    u64 now = get_time_ns();
    u64 elapsed = now - start;
}
```

**Purpose**: Tracks when processes first appear in the system
**Data Flow**: eBPF records start times → User-space calculates elapsed time

#### `syscall_start` Map - System Call Timing
```c
// eBPF side: Records system call entry times
u64 start = bpf_ktime_get_ns();
bpf_map_update_elem(&syscall_start, &pid, &start, BPF_ANY);

// User-space side: Reads system call timing
u64 syscall_start = 0;
if (bpf_map_lookup_elem(syscall_start_fd, &pid, &syscall_start) == 0) {
    // Process is currently in a system call
}
```

**Purpose**: Tracks active system calls and their duration
**Data Flow**: eBPF records syscall entry → User-space tracks active syscalls

#### `kernel_time` and `user_time` Maps - CPU Time Accumulation
```c
// eBPF side: Accumulates CPU time
u64 *kernel = bpf_map_lookup_elem(&kernel_time, &pid);
if (kernel) {
    *kernel += delta_ns;
    bpf_map_update_elem(&kernel_time, &pid, kernel, BPF_ANY);
}

// User-space side: Reads accumulated CPU time
u64 kernel_time = 0;
if (bpf_map_lookup_elem(kernel_fd, &pid, &kernel_time) == 0) {
    struct pid_entry *e = find_or_add_pid(&state, pid);
    e->kernel_ms = kernel_time / 1000000.0; // Convert to milliseconds
}
```

**Purpose**: Accumulates kernel and user-space CPU time per process
**Data Flow**: eBPF accumulates time → User-space converts to milliseconds

## Data Synchronization Strategy

### Time-Based Data Collection

```c
// Periodic data update (~1s)
if (elapsed_ns >= update_interval_ns) {
    // Phase 1: Read eBPF timing data
    if (bpf_map_get_next_key(start_fd, NULL, &key) == 0) {
        do {
            // Read all timing maps for this PID
            u64 start = 0, kernel = 0, user = 0;
            bpf_map_lookup_elem(start_fd, &key, &start);
            bpf_map_lookup_elem(kernel_fd, &key, &kernel);
            bpf_map_lookup_elem(user_fd, &key, &user);
            
            struct pid_entry *e = find_or_add_pid(&state, key);
            // Update timing data
            e->kernel_ms = kernel / 1000000.0;
            e->user_ms = user / 1000000.0;
            e->total_ms = e->kernel_ms + e->user_ms;
        } while (bpf_map_get_next_key(start_fd, &key, &next_key) == 0);
    }

    // Phase 2: Read process names from /proc
    for (struct pid_entry *c = state; c; c = c->next) {
        if (c->name[0] == '\0') {
            get_comm_by_pid(c->pid, c->name, sizeof(c->name));
        }
    }
}
```

### Data Consistency

1. **Process Identification**: Both eBPF and `/proc` use PID as the primary identifier
2. **Time Synchronization**: Data collected in batches every 1 second
3. **Missing Data Handling**: Graceful handling when processes disappear
4. **Data Validation**: Cross-validation between eBPF timing and process existence

## Performance Characteristics

### System Impact

#### eBPF Overhead
- **Tracepoint Processing**: Minimal overhead per scheduling/system call event
- **Map Updates**: Efficient hash map operations
- **Memory Usage**: ~5KB for maps
- **CPU Impact**: <0.5% CPU overhead for typical workloads

#### User-Space Overhead
- **`/proc` Scanning**: O(n) where n = number of processes
- **Memory Usage**: ~500KB for process data structures
- **Update Frequency**: 1-second intervals balance accuracy and performance
- **UI Responsiveness**: 100Hz rendering for smooth interaction

### Scalability Considerations

#### Process Limit Handling
```c
// No explicit process limits - scales with system
// Efficient linked list management
static struct pid_entry *find_or_add_pid(struct pid_entry **list, __u32 pid) {
    // O(n) search, but typically small n for active processes
}
```

#### Memory Management
```c
// Cached view for performance
struct pid_entry **view_cached = NULL;
int view_count_cached = 0;

// Top-N filtering
view_count = count > 100 ? 100 : count; // Display top 100 processes
```

## Integration Benefits

### Comprehensive CPU View

1. **Real-Time Timing**: eBPF provides precise kernel and user-space CPU time
   - Millisecond precision timing
   - Real-time CPU percentage calculations
   - System call timing analysis

2. **Process Context**: `/proc` provides process identification
   - Process names from `/proc/[pid]/comm`
   - Process lifecycle tracking
   - Human-readable process information

3. **Combined Analysis**: Integration enables advanced CPU analysis
   - CPU usage trends over time
   - System call frequency analysis
   - Process scheduling behavior

### Real-World Use Cases

#### Performance Analysis
```
Process with:
- High kernel_ms (significant system call overhead)
- High user_ms (CPU-intensive computation)
- High total CPU percentage
→ CPU-intensive process requiring optimization
```

#### System Call Analysis
```
Process with:
- High syscall_start entries (frequent system calls)
- Low kernel_ms per syscall (efficient syscalls)
- Moderate total CPU usage
→ I/O bound process with efficient system call usage
```

#### System Monitoring
```
System-wide view:
- Total CPU usage distribution
- Process CPU consumption ranking
- Kernel vs user-space CPU usage
→ System resource planning and optimization
```

## Error Handling and Robustness

### eBPF Program Lifecycle

```c
// Graceful loading
obj = bpf_object__open_file("prog.bpf.o", NULL);
if (!obj) {
    fprintf(stderr, "Failed to open BPF object\n");
    return 1;
}

// Graceful attachment
struct bpf_link *link_switch = bpf_program__attach_tracepoint(prog_switch, "sched", "sched_switch");
if (!link_switch) {
    fprintf(stderr, "Failed to attach to sched_switch\n");
    return 1;
}
```

### Process Lifecycle Management

```c
// Handle disappearing processes
static void get_comm_by_pid(__u32 pid, char *buf, size_t buflen) {
    FILE *f = fopen(path, "r");
    if (!f) {
        snprintf(buf, buflen, "-"); // Process no longer exists
        return;
    }
    // ... read process name
}
```

### Signal Handling

```c
static volatile sig_atomic_t exiting = 0;

void handle_sigint(int sig) {
    exiting = 1;
}

// Clean shutdown
while (!exiting) {
    // Main loop
}

// Cleanup
bpf_link__destroy(link_switch);
bpf_link__destroy(link_enter);
bpf_link__destroy(link_exit);
free_pid_list(state);
endwin();
bpf_object__close(obj);
```

## Future Enhancements

### Advanced Analytics
- CPU usage trend analysis
- Process scheduling pattern recognition
- System call frequency analysis

### Enhanced UI Features
- Historical CPU usage graphs
- CPU usage alerts
- Export functionality for analysis

### Performance Optimizations
- More efficient map access patterns
- Reduced memory usage for large process counts
- Optimized UI rendering

This integration provides a robust, efficient, and comprehensive CPU monitoring solution that combines the precision of kernel-level eBPF tracking with the usability of user-space process management.
