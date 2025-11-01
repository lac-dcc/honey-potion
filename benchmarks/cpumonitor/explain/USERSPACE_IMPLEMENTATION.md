# CPU Monitor - User-Space Implementation

## Overview

This document explains the user-space implementation of the CPU monitor, which provides a real-time, interactive view of process CPU usage using eBPF for data collection and ncurses for the user interface.

## Architecture Decisions

### Why This Approach?

1. **eBPF for Data Collection**: eBPF allows us to collect kernel-level data with minimal overhead and no context switching between user and kernel space.

2. **ncurses for UI**: Provides a responsive, terminal-based interface that can run on any system without GUI dependencies.

3. **Decoupled Design**: Separates data collection (1Hz) from UI rendering (100Hz) for smooth user interaction.

4. **Top-N Filtering**: Shows only the 100 most CPU-intensive processes to avoid information overload.

## Data Structures

### `struct pid_entry`

```c
struct pid_entry {
    __u32 pid;                    // Process ID
    char name[64];                // Process name from /proc/<pid>/comm
    double total_ms;              // Cumulative total CPU time (ms)
    double kernel_ms;             // Cumulative kernel time (ms)
    double user_ms;               // Cumulative user time (ms)
    double pct_total;             // Current smoothed CPU percentage (total)
    double pct_kernel;            // Current smoothed CPU percentage (kernel)
    double pct_user;              // Current smoothed CPU percentage (user)
    double smoothed_pct_total;    // Exponential moving average for total %
    double smoothed_pct_kernel;   // Exponential moving average for kernel %
    double smoothed_pct_user;     // Exponential moving average for user %
    unsigned long long prev_kernel_ns;  // Previous kernel time (ns) for delta calc
    unsigned long long prev_user_ns;    // Previous user time (ns) for delta calc
    struct pid_entry *next;       // Linked list pointer
};
```

**Design Rationale**:
- **Linked List**: Simple, dynamic structure that grows as new processes appear
- **Cumulative + Instantaneous**: Stores both cumulative times and current percentages
- **Smoothing Fields**: Separate fields for raw and smoothed percentages to avoid jitter
- **Previous Values**: Store previous measurements to compute deltas

## Key Functions

### Process Management

#### `find_or_add_pid()`
```c
static struct pid_entry *find_or_add_pid(struct pid_entry **list, __u32 pid)
```

**Purpose**: Efficiently find existing process or create new entry.

**Design Decisions**:
- **Linear Search**: Simple for small process counts; could be optimized with hash table for 1000+ processes
- **Head Insertion**: New processes added to head for O(1) insertion
- **calloc()**: Zero-initializes all fields, ensuring clean state

#### `get_comm_by_pid()`
```c
static void get_comm_by_pid(__u32 pid, char *buf, size_t buflen)
```

**Purpose**: Read process name from `/proc/<pid>/comm`.

**Design Decisions**:
- **comm vs stat**: Uses `comm` (shorter, cleaner names) instead of `stat` (full command line)
- **Error Handling**: Sets name to "-" if process not found or error occurs
- **Newline Trimming**: Removes trailing newline from file read

### CPU Percentage Calculation

#### Delta Computation
```c
unsigned long long d_kernel = 0;
unsigned long long d_user = 0;
if (e->prev_kernel_ns > 0 || e->prev_user_ns > 0) {
    if (kernel >= e->prev_kernel_ns)
        d_kernel = kernel - e->prev_kernel_ns;
    if (user >= e->prev_user_ns)
        d_user = user - e->prev_user_ns;
}
```

**Why This Approach**:
- **Cumulative Values**: eBPF maps store cumulative CPU time, so we compute deltas
- **Overflow Protection**: Checks for negative deltas (can happen with process restarts)
- **First Run Handling**: Skips calculation on first measurement

#### Percentage Normalization
```c
double denom = interval_ns * (double)num_cpus;
double inst_total = denom > 0 ? (100.0 * (double)d_total / denom) : 0.0;
```

**Formula**: `CPU% = (delta_time / (interval_time × num_cpus)) × 100`

**Why Multiply by CPUs**:
- **Per-CPU Normalization**: A process using 100% of one CPU on a 4-CPU system should show 25%
- **Accurate Representation**: Prevents percentages > 100% on multi-core systems

### Smoothing Algorithm

#### Exponential Moving Average (EMA)
```c
e->smoothed_pct_total = alpha * inst_total + (1.0 - alpha) * e->smoothed_pct_total;
```

**Parameters**:
- **alpha = 0.3**: 30% weight to new value, 70% to history
- **Lower alpha**: More smoothing, less responsive
- **Higher alpha**: More responsive, more jitter

**Why EMA vs Simple Average**:
- **Memory Efficient**: No need to store historical values
- **Adaptive**: Recent values have more influence
- **Smooth Decay**: Gradual transition rather than sudden drops

## UI Implementation

### Rendering Loop Design

#### Dual-Frequency Architecture
```c
// Data update: ~1Hz
if (elapsed_ns >= update_interval_ns) {
    // Update data from eBPF maps
}

// UI render: ~100Hz
struct timespec tiny = { .tv_sec = 0, .tv_nsec = 10000000 }; // 10ms
nanosleep(&tiny, NULL);
```

**Benefits**:
- **Responsive Scrolling**: Input handled at 100Hz
- **Stable Data**: Updates at 1Hz prevent constant re-sorting
- **CPU Efficient**: Minimal overhead between renders

#### Cached View System
```c
struct pid_entry **view_cached = NULL;
int view_count_cached = 0;
```

**Why Cache the View**:
- **Performance**: Avoids re-sorting on every render
- **Stability**: Scrolling position maintained during updates
- **Memory Management**: Single allocation per update cycle

### Sorting Strategy

#### Two-Phase Sorting
```c
// Phase 1: Sort by CPU usage (descending)
qsort(arr, count, sizeof(*arr), compare_pid_entries_desc_total);

// Phase 2: Sort top 100 by name (ascending)
qsort(view, view_count, sizeof(*view), compare_pid_entries_name_asc);
```

**Rationale**:
- **Phase 1**: Selects the most CPU-intensive processes
- **Phase 2**: Provides stable, alphabetical ordering for easy scanning
- **Top 100 Limit**: Prevents UI clutter and focuses on relevant processes

### Input Handling

#### Non-Blocking Input
```c
nodelay(stdscr, TRUE);
while ((ch = getch()) != ERR) {
    // Handle input
}
```

**Benefits**:
- **Responsive**: No waiting for user input
- **Smooth Scrolling**: Continuous updates while scrolling
- **Multiple Keys**: Can handle rapid key presses

#### Scroll Bounds Checking
```c
if (scroll < 0) scroll = 0;
if (view_cached && scroll > view_count_cached - 1) scroll = view_count_cached - 1;
```

**Safety**: Prevents scrolling beyond available data.

## Performance Optimizations

### Memory Management
- **Single Allocation**: One malloc per update cycle for view array
- **Immediate Free**: Freed at end of each update cycle
- **No Memory Leaks**: All allocations have corresponding frees

### CPU Efficiency
- **Conditional Updates**: Only updates when 1 second has elapsed
- **Efficient Sorting**: Only sorts when data changes
- **Minimal I/O**: Only reads `/proc` files when needed

### UI Responsiveness
- **Cached Rendering**: Uses pre-computed view for display
- **Fast Input Loop**: Minimal processing in input handling
- **Efficient Drawing**: Only redraws changed portions

## Error Handling

### eBPF Map Access
```c
if (bpf_map_lookup_elem(kernel_fd, &key, &kernel) == 0 &&
    bpf_map_lookup_elem(user_fd, &key, &user) == 0) {
    // Process data
}
```

**Graceful Degradation**: Continues operation even if some map lookups fail.

### Process Name Resolution
```c
if (e->name[0] == '\0' || e->name[0] == '-') {
    get_comm_by_pid(key, e->name, sizeof(e->name));
}
```

**Retry Logic**: Attempts to resolve names for processes that previously failed.

## Configuration Parameters

### Timing Parameters
- **update_interval_ns = 1e9**: 1 second data update interval
- **alpha = 0.3**: EMA smoothing factor
- **render_sleep = 10ms**: UI refresh rate

### Display Limits
- **max_processes = 100**: Maximum processes to display
- **name_width = 20**: Maximum process name width
- **decimal_places = 2**: CPU percentage precision

## Thread Safety Considerations

**Single-Threaded Design**: The entire application runs in a single thread, avoiding:
- Race conditions between data updates and UI rendering
- Complex synchronization mechanisms
- Potential deadlocks

**Atomic Operations**: Uses simple data types and avoids complex shared state.

## Future Enhancement Opportunities

### Performance
1. **Hash Table**: Replace linked list with hash table for O(1) lookups
2. **Circular Buffer**: For historical data storage
3. **Multi-threading**: Separate data collection from UI rendering

### Features
1. **Process Filtering**: Filter by name, PID range, or CPU threshold
2. **Sorting Options**: Sort by different criteria (PID, name, memory, etc.)
3. **Historical View**: Show CPU usage trends over time
4. **Process Tree**: Show parent-child relationships

### UI Improvements
1. **Color Coding**: Highlight high CPU usage processes
2. **Search Functionality**: Find specific processes quickly
3. **Configuration Menu**: Adjust parameters at runtime
4. **Export Data**: Save data to file for analysis

## Interaction with eBPF Code

The user-space code interacts with the eBPF program through:

1. **Map Access**: Reads cumulative CPU times from `kernel_time` and `user_time` maps
2. **Data Processing**: Converts raw nanosecond values to percentages
3. **Process Resolution**: Maps PIDs to process names for display
4. **Real-time Updates**: Continuously polls maps for new data

The eBPF program provides the raw data, while the user-space code handles:
- Data interpretation and formatting
- User interface and interaction
- Process name resolution
- Data smoothing and filtering
- Display management

This separation allows the eBPF program to focus on efficient data collection while the user-space code handles the complex UI and data processing logic.
