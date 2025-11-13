# Memory Monitor - User-Space Implementation

## Overview

This document explains the user-space implementation of the memory monitor, which provides a real-time, interactive view of process memory usage using eBPF for data collection and ncurses for the user interface. The implementation combines eBPF-collected allocation statistics with real-time memory usage data from `/proc` filesystem.

## Architecture Decisions

### Why This Hybrid Approach?

1. **eBPF for Allocation Tracking**: eBPF captures memory allocation events (mmap, munmap, brk) at the kernel level with minimal overhead.

2. **`/proc` for Current Usage**: Real-time memory usage (RSS, Virtual, Peak) is read from `/proc/[pid]/status` for accurate current values.

3. **ncurses for UI**: Provides a responsive, terminal-based interface that can run on any system without GUI dependencies.

4. **Decoupled Design**: Separates data collection (3s) from UI rendering (100Hz) for smooth user interaction.

5. **Top-N Filtering**: Shows only the 100 processes with highest memory usage to avoid information overload.

## Data Structures

### `struct pid_entry`

```c
struct pid_entry {
    __u32 pid;                    // Process ID
    char name[64];                // Process name from /proc/<pid>/comm
    __u64 total_allocated;        // Total bytes allocated (eBPF)
    __u64 total_freed;            // Total bytes freed (eBPF)
    __u64 current_usage;          // Current usage from eBPF tracking
    __u64 peak_usage;             // Peak usage from eBPF tracking
    __u64 alloc_count;            // Number of allocation operations (eBPF)
    __u64 free_count;             // Number of deallocation operations (eBPF)
    __u64 mmap_count;             // Number of mmap operations (eBPF)
    __u64 munmap_count;           // Number of munmap operations (eBPF)
    __u64 last_update;            // Timestamp of last update (eBPF)
    // Real memory usage from /proc
    __u64 rss_kb;                 // Current RSS from /proc/status
    __u64 virtual_kb;             // Virtual memory from /proc/status
    __u64 peak_rss_kb;            // Peak RSS from /proc/status
    struct pid_entry *next;       // Linked list pointer
};
```

**Key Design Decisions**:
- **Hybrid Data**: Combines eBPF allocation tracking with `/proc` current usage
- **Linked List**: Efficient dynamic memory management for process entries
- **Real-time Values**: Uses `/proc` data for accurate current memory display

## Core Functions

### Process Management

#### `find_or_add_pid()`
```c
static struct pid_entry *find_or_add_pid(struct pid_entry **list, __u32 pid) {
    struct pid_entry *cur = *list;
    while (cur) {
        if (cur->pid == pid)
            return cur;
        cur = cur->next;
    }
    struct pid_entry *node = calloc(1, sizeof(struct pid_entry));
    if (!node) return NULL;
    node->pid = pid;
    node->next = *list;
    (*list) = node;
    return node;
}
```

**Purpose**: Efficiently manages process entries in a linked list
**Features**:
- **O(n) Search**: Linear search through linked list
- **Dynamic Allocation**: Creates new entries as needed
- **Memory Efficient**: Only allocates memory for active processes

#### `get_comm_by_pid()`
```c
static void get_comm_by_pid(__u32 pid, char *buf, size_t buflen) {
    char path[64];
    snprintf(path, sizeof(path), "/proc/%u/comm", pid);
    FILE *f = fopen(path, "r");
    if (!f) {
        snprintf(buf, buflen, "-");
        return;
    }
    if (!fgets(buf, buflen, f)) {
        snprintf(buf, buflen, "-");
        fclose(f);
        return;
    }
    fclose(f);
    size_t len = strlen(buf);
    if (len > 0 && buf[len - 1] == '\n') buf[len - 1] = '\0';
}
```

**Purpose**: Retrieves process name from `/proc/[pid]/comm`
**Features**:
- **Error Handling**: Graceful handling of missing processes
- **String Processing**: Removes newline characters
- **Safe Buffer**: Prevents buffer overflows

### Memory Usage Reading

#### `get_real_memory_usage()`
```c
static void get_real_memory_usage(__u32 pid, __u64 *rss_kb, __u64 *virtual_kb, __u64 *peak_rss_kb) {
    char path[64];
    snprintf(path, sizeof(path), "/proc/%u/status", pid);
    FILE *f = fopen(path, "r");
    if (!f) {
        *rss_kb = 0;
        *virtual_kb = 0;
        *peak_rss_kb = 0;
        return;
    }
    
    char line[256];
    while (fgets(line, sizeof(line), f)) {
        if (strncmp(line, "VmRSS:", 6) == 0) {
            char *ptr = strtok(line, " \t");
            ptr = strtok(NULL, " \t"); // Get the number
            if (ptr) {
                char *newline = strchr(ptr, '\n');
                if (newline) *newline = '\0';
                *rss_kb = strtoul(ptr, NULL, 10);
            }
        } else if (strncmp(line, "VmSize:", 7) == 0) {
            // Similar parsing for VmSize
        } else if (strncmp(line, "VmHWM:", 6) == 0) {
            // Similar parsing for VmHWM (Peak RSS)
        }
    }
    fclose(f);
}
```

**Purpose**: Reads real-time memory usage from `/proc/[pid]/status`
**Key Features**:
- **Robust Parsing**: Uses `strtok` to handle varying whitespace in `/proc` files
- **Error Handling**: Graceful handling of missing or inaccessible processes
- **Multiple Metrics**: Reads RSS, Virtual, and Peak memory usage

### Sorting and Display

#### `compare_pid_entries_desc_memory()`
```c
static int compare_pid_entries_desc_memory(const void *va, const void *vb) {
    const struct pid_entry *const *a = (const struct pid_entry *const *)va;
    const struct pid_entry *const *b = (const struct pid_entry *const *)vb;
    // Sort by real RSS memory usage (from /proc)
    if ((*b)->rss_kb > (*a)->rss_kb) return 1;
    if ((*b)->rss_kb < (*a)->rss_kb) return -1;
    if ((*a)->pid < (*b)->pid) return -1;
    if ((*a)->pid > (*b)->pid) return 1;
    return 0;
}
```

**Purpose**: Sorts processes by memory usage (highest first)
**Features**:
- **Primary Sort**: By RSS memory usage (real current usage)
- **Secondary Sort**: By PID for consistent ordering
- **Descending Order**: Highest memory usage first

## eBPF Integration

### Program Loading and Attachment

```c
int main() {
    struct bpf_object *obj;
    int err;

    // Load eBPF object
    obj = bpf_object__open_file("prog.bpf.o", NULL);
    if (!obj) {
        fprintf(stderr, "Failed to open BPF object\n");
        return 1;
    }

    err = bpf_object__load(obj);
    if (err) {
        fprintf(stderr, "Failed to load BPF object: %d\n", err);
        return 1;
    }

    // Attach to memory-related tracepoints
    struct bpf_program *prog_mmap = bpf_object__find_program_by_name(obj, "trace_mmap_enter");
    struct bpf_link *link_mmap = bpf_program__attach_tracepoint(prog_mmap, "syscalls", "sys_enter_mmap");
    
    struct bpf_program *prog_munmap = bpf_object__find_program_by_name(obj, "trace_munmap_enter");
    struct bpf_link *link_munmap = bpf_program__attach_tracepoint(prog_munmap, "syscalls", "sys_enter_munmap");
    
    struct bpf_program *prog_brk = bpf_object__find_program_by_name(obj, "trace_brk_enter");
    struct bpf_link *link_brk = bpf_program__attach_tracepoint(prog_brk, "syscalls", "sys_enter_brk");
}
```

**Key Steps**:
1. **Load Object**: Load compiled eBPF program
2. **Attach Programs**: Attach to specific tracepoints
3. **Get Map FD**: Get file descriptor for BPF maps

### Data Collection Loop

```c
// Periodic data update (~3s)
if (elapsed_ns >= update_interval_ns) {
    // First, read eBPF statistics
    if (bpf_map_get_next_key(mem_stats_fd, NULL, &key) == 0) {
        do {
            if (bpf_map_lookup_elem(mem_stats_fd, &key, &stats) == 0) {
                struct pid_entry *e = find_or_add_pid(&state, key);
                // Update eBPF statistics
                e->total_allocated = stats.total_allocated;
                e->mmap_count = stats.mmap_count;
                // ... other eBPF fields
            }
        } while (bpf_map_get_next_key(mem_stats_fd, &key, &next_key) == 0);
    }

    // Then, scan /proc for all processes and read real memory usage
    DIR *proc_dir = opendir("/proc");
    if (proc_dir) {
        struct dirent *entry;
        while ((entry = readdir(proc_dir)) != NULL) {
            if (entry->d_type == DT_DIR && entry->d_name[0] >= '0' && entry->d_name[0] <= '9') {
                __u32 pid = atoi(entry->d_name);
                struct pid_entry *e = find_or_add_pid(&state, pid);
                // Get real memory usage from /proc
                get_real_memory_usage(pid, &e->rss_kb, &e->virtual_kb, &e->peak_rss_kb);
            }
        }
        closedir(proc_dir);
    }
}
```

**Hybrid Data Collection**:
1. **eBPF Data**: Reads allocation statistics from BPF maps
2. **`/proc` Data**: Scans all processes and reads current memory usage
3. **Combined View**: Merges both data sources for comprehensive monitoring

## User Interface

### ncurses Integration

```c
// Prepare ncurses UI
initscr();
cbreak();
noecho();
keypad(stdscr, TRUE);
nodelay(stdscr, TRUE);
curs_set(0);

// Display loop
while (!exiting) {
    // Input handling
    int ch;
    while ((ch = getch()) != ERR) {
        if (ch == 'q' || ch == 'Q') { exiting = 1; break; }
        else if (ch == KEY_UP) { if (scroll > 0) scroll--; }
        else if (ch == KEY_DOWN) { if (view_cached && scroll < (view_count_cached - 1)) scroll++; }
        // ... other input handling
    }

    // Display
    clear();
    mvprintw(0, 0, "Memory Monitor - q: quit  ↑/↓: scroll");
    mvprintw(1, 0, "%-7s %-20s %12s %12s %12s %8s %8s",
             "PID", "NAME", "RSS(MB)", "VIRT(MB)", "PEAK(MB)", "MMAP#", "MUNMAP#");
    
    // Display process data
    for (int i = start; i < end; i++, row++) {
        struct pid_entry *e = view_cached[i];
        mvprintw(row, 0, "%-7u %-20.20s %12.1f %12.1f %12.1f %8llu %8llu",
                 e->pid, e->name,
                 e->rss_kb / 1024.0,
                 e->virtual_kb / 1024.0,
                 e->peak_rss_kb / 1024.0,
                 e->mmap_count,
                 e->munmap_count);
    }
    refresh();
}
```

**UI Features**:
- **Real-time Updates**: Updates every 3 seconds
- **Interactive Scrolling**: Up/down arrow keys for navigation
- **Responsive Input**: 100Hz input polling for smooth interaction
- **Clean Display**: Clear formatting with proper alignment

## Performance Optimizations

### Caching Strategy

```c
struct pid_entry **view_cached = NULL;
int view_count_cached = 0;

// Rebuild cached view only when data changes
if (elapsed_ns >= update_interval_ns) {
    // ... collect data ...
    
    // Rebuild cached view
    qsort(arr, count, sizeof(*arr), compare_pid_entries_desc_memory);
    view_count = count > 100 ? 100 : count;
    
    if (view_cached) free(view_cached);
    view_cached = view;
    view_count_cached = view_count;
}
```

**Optimizations**:
1. **Cached View**: Pre-sorted, filtered view updated only every 3 seconds
2. **Top-N Filtering**: Limits display to top 100 processes
3. **Efficient Sorting**: Only sorts when data changes
4. **Memory Management**: Proper cleanup of cached data

### Input/Output Separation

```c
// Data collection: 3Hz
if (elapsed_ns >= update_interval_ns) {
    // Collect data
}

// UI rendering: 100Hz
clear();
// Display cached data
refresh();

// Smooth input handling
struct timespec tiny = { .tv_sec = 0, .tv_nsec = 10000000 };
nanosleep(&tiny, NULL);
```

**Benefits**:
- **Responsive UI**: 100Hz rendering for smooth interaction
- **Efficient Data Collection**: 3Hz data collection reduces system load
- **Decoupled Design**: UI performance independent of data collection performance

## Integration Benefits

### Combined Data Sources

1. **eBPF Allocation Tracking**: Provides insight into memory allocation patterns
   - Total allocations/deallocations
   - Allocation frequency (mmap/munmap counts)
   - Memory allocation trends

2. **`/proc` Current Usage**: Provides accurate real-time memory consumption
   - Current RSS (Resident Set Size)
   - Virtual memory usage
   - Peak memory usage

3. **Comprehensive View**: Combines allocation patterns with current usage
   - Shows which processes are actively allocating memory
   - Displays current memory consumption
   - Enables identification of memory-intensive processes

### Real-World Use Cases

1. **Memory Leak Detection**: High allocation counts with low current usage may indicate leaks
2. **Performance Analysis**: Identify processes with high memory allocation frequency
3. **Resource Monitoring**: Track memory usage patterns over time
4. **System Optimization**: Identify memory-intensive processes for optimization

## Error Handling and Robustness

### Process Lifecycle Management

```c
// Handle disappearing processes gracefully
if (!f) {
    *rss_kb = 0;
    *virtual_kb = 0;
    *peak_rss_kb = 0;
    return;
}
```

### Memory Management

```c
static void free_pid_list(struct pid_entry *list) {
    while (list) {
        struct pid_entry *tmp = list;
        list = list->next;
        free(tmp);
    }
}
```

### Signal Handling

```c
static volatile sig_atomic_t exiting = 0;

void handle_sigint(int sig) {
    exiting = 1;
}

signal(SIGINT, handle_sigint);
```