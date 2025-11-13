# Memory Monitor - System Integration

## Overview

This document explains how the eBPF kernel program and user-space program work together to provide comprehensive memory monitoring. The integration combines real-time kernel-level memory allocation tracking with user-space memory usage monitoring to create a complete picture of system memory behavior.

### Component Interaction

1. **Kernel Events**: Memory allocation system calls trigger eBPF tracepoints
2. **eBPF Processing**: Tracepoint handlers update BPF maps with allocation statistics
3. **User-Space Reading**: Program reads from BPF maps and `/proc` filesystem
4. **Data Integration**: Combines eBPF allocation data with real-time memory usage
5. **Display**: Shows integrated view in ncurses interface

## eBPF ↔ User-Space Communication

### BPF Maps as Communication Channels

#### `mem_stats_map` - Statistics Channel
```c
// eBPF side: Updates statistics
struct mem_stats *stats = bpf_map_lookup_elem(&mem_stats_map, &pid);
if (stats) {
    stats->total_allocated += size;
    stats->mmap_count++;
    stats->last_update = bpf_ktime_get_ns();
    bpf_map_update_elem(&mem_stats_map, &pid, stats, BPF_ANY);
}

// User-space side: Reads statistics
struct mem_stats stats = {};
if (bpf_map_lookup_elem(mem_stats_fd, &key, &stats) == 0) {
    struct pid_entry *e = find_or_add_pid(&state, key);
    e->total_allocated = stats.total_allocated;
    e->mmap_count = stats.mmap_count;
    // ... update other fields
}
```

**Data Flow**:
- **eBPF**: Updates statistics when memory operations occur
- **User-Space**: Reads statistics every 3 seconds
- **Purpose**: Provides allocation patterns and trends

#### `mem_events` - Event Stream Channel
```c
// eBPF side: Sends events
struct mem_event *event = bpf_ringbuf_reserve(&mem_events, sizeof(*event), 0);
if (event) {
    event->timestamp = bpf_ktime_get_ns();
    event->pid = pid;
    event->size = size;
    event->event_type = 2; // mmap
    bpf_ringbuf_submit(event, 0);
}

// User-space side: Consumes events (future enhancement)
// Currently not used in main implementation but available for real-time event processing
```

**Purpose**: Provides real-time event streaming for immediate notification of memory operations

### `/proc` Filesystem Integration

#### Real-Time Memory Usage Reading
```c
// User-space reads current memory usage
static void get_real_memory_usage(__u32 pid, __u64 *rss_kb, __u64 *virtual_kb, __u64 *peak_rss_kb) {
    char path[64];
    snprintf(path, sizeof(path), "/proc/%u/status", pid);
    FILE *f = fopen(path, "r");
    // Parse VmRSS, VmSize, VmHWM from /proc/[pid]/status
}
```

**Integration Points**:
- **Process Discovery**: Scans `/proc` to find all running processes
- **Memory Metrics**: Reads current RSS, Virtual, and Peak memory usage
- **Process Names**: Reads process names from `/proc/[pid]/comm`

## Data Synchronization Strategy

### Hybrid Data Collection

```c
// Periodic data update (~3s)
if (elapsed_ns >= update_interval_ns) {
    // Phase 1: Read eBPF allocation statistics
    if (bpf_map_get_next_key(mem_stats_fd, NULL, &key) == 0) {
        do {
            if (bpf_map_lookup_elem(mem_stats_fd, &key, &stats) == 0) {
                struct pid_entry *e = find_or_add_pid(&state, key);
                // Update eBPF-derived fields
                e->total_allocated = stats.total_allocated;
                e->mmap_count = stats.mmap_count;
                // ...
            }
        } while (bpf_map_get_next_key(mem_stats_fd, &key, &next_key) == 0);
    }

    // Phase 2: Read real-time memory usage from /proc
    DIR *proc_dir = opendir("/proc");
    if (proc_dir) {
        struct dirent *entry;
        while ((entry = readdir(proc_dir)) != NULL) {
            if (entry->d_type == DT_DIR && entry->d_name[0] >= '0' && entry->d_name[0] <= '9') {
                __u32 pid = atoi(entry->d_name);
                struct pid_entry *e = find_or_add_pid(&state, pid);
                // Update real-time memory usage
                get_real_memory_usage(pid, &e->rss_kb, &e->virtual_kb, &e->peak_rss_kb);
            }
        }
        closedir(proc_dir);
    }
}
```

### Data Consistency

1. **Process Identification**: Both eBPF and `/proc` use PID as the primary identifier
2. **Time Synchronization**: Data collected in batches every 3 seconds
3. **Missing Data Handling**: Graceful handling when processes disappear or eBPF data is unavailable
4. **Data Validation**: Cross-validation between eBPF and `/proc` data sources

## Performance Characteristics

### System Impact

#### eBPF Overhead
- **Tracepoint Processing**: Minimal overhead per memory allocation
- **Map Updates**: Efficient hash map operations
- **Memory Usage**: ~10KB for maps, ~256KB for ring buffer
- **CPU Impact**: <1% CPU overhead for typical workloads

#### User-Space Overhead
- **`/proc` Scanning**: O(n) where n = number of processes
- **Memory Usage**: ~1MB for process data structures
- **Update Frequency**: 3-second intervals reduce system load
- **UI Responsiveness**: 100Hz rendering for smooth interaction

### Scalability Considerations

#### Process Limit Handling
```c
// eBPF map size limits
__uint(max_entries, 10240);  // Max 10,240 processes tracked

// User-space filtering
view_count = count > 100 ? 100 : count; // Display top 100 processes
```

#### Memory Management
```c
// Efficient linked list management
static struct pid_entry *find_or_add_pid(struct pid_entry **list, __u32 pid) {
    // O(n) search, but typically small n for active processes
}

// Cached view for performance
struct pid_entry **view_cached = NULL;
int view_count_cached = 0;
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
struct bpf_link *link_mmap = bpf_program__attach_tracepoint(prog_mmap, "syscalls", "sys_enter_mmap");
if (!link_mmap) {
    fprintf(stderr, "Failed to attach to sys_enter_mmap\n");
    return 1;
}
```

### Process Lifecycle Management

```c
// Handle disappearing processes
static void get_real_memory_usage(__u32 pid, __u64 *rss_kb, __u64 *virtual_kb, __u64 *peak_rss_kb) {
    FILE *f = fopen(path, "r");
    if (!f) {
        *rss_kb = 0;        // Process no longer exists
        *virtual_kb = 0;
        *peak_rss_kb = 0;
        return;
    }
    // ... parse data
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
bpf_link__destroy(link_mmap);
bpf_link__destroy(link_munmap);
bpf_link__destroy(link_brk);
free_pid_list(state);
endwin();
bpf_object__close(obj);
```

## Integration Benefits

### Comprehensive Memory View

1. **Allocation Patterns**: eBPF provides insight into how processes allocate memory
   - Frequency of allocations (mmap/munmap counts)
   - Total allocation amounts
   - Allocation trends over time

2. **Current Usage**: `/proc` provides accurate real-time memory consumption
   - Current RSS (Resident Set Size)
   - Virtual memory usage
   - Peak memory usage

3. **Combined Analysis**: Integration enables advanced memory analysis
   - Memory leak detection (high allocations, low current usage)
   - Fragmentation analysis (many small allocations)
   - Performance optimization (identify memory-intensive processes)

### Real-World Use Cases

#### Memory Leak Detection
```
Process with:
- High mmap_count (many allocations)
- Low current RSS (little memory actually used)
- Large total_allocated vs total_freed difference
→ Potential memory leak
```

#### Performance Analysis
```
Process with:
- High mmap_count (frequent allocations)
- High current RSS (significant memory usage)
- High peak usage
→ Memory-intensive process requiring optimization
```

#### System Monitoring
```
System-wide view:
- Total allocation activity
- Memory usage distribution
- Process memory consumption ranking
→ System resource planning and optimization
```

## Future Enhancements

### Real-Time Event Processing
- Use `mem_events` ring buffer for immediate event notification
- Implement real-time memory leak detection
- Add memory allocation rate monitoring

### Advanced Analytics
- Memory fragmentation analysis
- Allocation pattern recognition
- Predictive memory usage modeling

### Enhanced UI Features
- Historical memory usage graphs
- Memory usage alerts
- Export functionality for analysis