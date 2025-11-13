# Network Monitor - User-Space Implementation

## Overview

The Network Monitor user-space frontend provides an ncurses experience similar to `cpumonitor`, but optimized for traffic metrics. It connects to the eBPF maps, computes bandwidth, applies smoothing, and highlights anomalies. This document describes the structures, algorithms, and design decisions involved.

## Architecture

### Main components

1. **libbpf loader** — opens the compiled object, creates maps, and attaches tracepoints.
2. **Update loop** — every 1000 ms (1 second) reads `traffic_map`, `pid_stats`, `protocol_totals`, and `anomaly_map`.
3. **Computation engine** — converts counters to rates, applies EMA, and infers metadata.
4. **ncurses UI** — renders a scrollable table and handles user commands (`q`, arrow keys).

### Design motivations

- **ncurses**: consistent UX with other benchmarks; no graphical dependencies.
- **Dual loop**: separates collection (1000 ms) from rendering (10 ms) to keep interactions smooth.
- **Immutable cache**: minimises reallocations and resorting during rendering.

## Data Structures

### `struct traffic_entry`
```c
struct traffic_entry {
    struct traffic_key key;
    char name[64];
    __u64 bytes_sent;
    __u64 bytes_recv;
    __u64 packets_sent;
    __u64 packets_recv;
    double bandwidth_sent;
    double bandwidth_recv;
    double bandwidth_total;
    double smoothed_bandwidth;
    __u64 last_seen_ns;
};
```

**Highlights**:
- Keeps a copy of the key so user space can write back into `anomaly_map`.
- Maintains both directional metrics (send/receive) and aggregates.
- `last_seen_ns` skips recomputation when the kernel has not updated the entry.

### View cache
```c
static struct traffic_entry **view_cached;
static int view_count_cached;
static int scroll;
```
- `view_cached`: pointer array used to sort without moving structs.
- `scroll`: offset of the first displayed row.
- Updated only after each collection cycle.

## Collection Pipeline

### 1. Reading maps
```c
__u32 key = 0, next_key;
while (bpf_map_get_next_key(traffic_fd, &key, &next_key) == 0) {
    struct traffic_stats stats;
    if (bpf_map_lookup_elem(traffic_fd, &next_key, &stats) == 0) {
        struct traffic_entry *e = find_or_add_entry(&entries, &next_key);
        merge_stats(e, &stats, now_ns);
    }
    key = next_key;
}
```
- Iterates `traffic_map` and synchronises it with the local list.
- `merge_stats` updates bytes, packet counters, and timestamps.

### 2. Enriching with `pid_stats`
```c
if (bpf_map_lookup_elem(pid_fd, &pid, &stats) == 0) {
    entry->bytes_sent = stats.bytes_sent;
    entry->bytes_recv = stats.bytes_recv;
}
```
- Keeps totals consistent when the traffic key lacks IP/port detail.

### 3. Resolving names
```c
if (entry->name[0] == '\0')
    get_comm_by_pid(entry->key.pid, entry->name, sizeof(entry->name));
```
- Reads `/proc/<pid>/comm`, falling back to `"N/A"` if the process is gone.

## Bandwidth Calculation

### Deltas and time
```c
double delta_sent = (double)(entry->bytes_sent - prev_sent);
double interval = (now_ns - entry->last_seen_ns) / 1e9;
double rate_sent = interval > 0 ? delta_sent / interval : 0.0;
```
- Requires storing previous totals for each entry.
- Short intervals yield more responsive rate updates.

### Smoothing (EMA)
```c
const double alpha = 0.4;
entry->smoothed_bandwidth = alpha * rate_total +
                            (1.0 - alpha) * entry->smoothed_bandwidth;
```
- Prevents transient spikes from triggering false positives.
- The smoothed value drives the anomaly logic.

## ncurses Rendering

### Header
```c
mvprintw(0, 0, "Network Monitor - q: quit  ↑/↓: scroll");
mvprintw(1, 0, "%-7s %-20s %-6s %12s %12s %12s",
         "PID", "PROCESS", "PROTO", "SENT", "RECV", "BANDWIDTH");
```
- Protocol totals are printed on line 2 using `protocol_totals`.

### Table body
```c
for (int i = scroll; i < end; i++) {
    struct traffic_entry *e = view_cached[i];
    if (is_kernel_thread(e->key.pid, e->name)) continue;

    char sent_str[32], recv_str[32], bw_display[32];
    format_bytes(e->bytes_sent, sent_str, sizeof(sent_str));
    format_bytes(e->bytes_recv, recv_str, sizeof(recv_str));
    format_bandwidth(e, bw_display, sizeof(bw_display));

    if (e->smoothed_bandwidth > threshold)
        attron(A_REVERSE);

    mvprintw(row++, 0, "%-7u %-20.20s %-6s %12s %12s %12s",
             e->key.pid, e->name, get_protocol_name(e->key.protocol),
             sent_str, recv_str, bw_display);

    if (e->smoothed_bandwidth > threshold)
        attroff(A_REVERSE);
}
```
- Highlighted rows indicate connections exceeding 10 MB/s.
- `format_bandwidth` prints `<value>/s` when sufficient history exists.

### Anomaly footer
```c
if (anomaly_count > 0)
    mvprintw(LINES - 1, 0, "⚠️  ALERT: %d high-bandwidth connections detected (>10 MB/s)", anomaly_count);
else
    mvprintw(LINES - 1, 0, "✓ No anomalies detected");
```
- Provides immediate feedback on the current alert status.

## User Input

```c
int ch;
while ((ch = getch()) != ERR) {
    if (ch == 'q') exiting = 1;
    else if (ch == KEY_UP) scroll = MAX(scroll - 1, 0);
    else if (ch == KEY_DOWN) scroll = MIN(scroll + 1, max_scroll);
}
```
- `nodelay(stdscr, TRUE)` keeps the loop non-blocking.
- `scroll` is clamped to the size of the cached view.

## Operational Practices

- **Cleanup**: detaches links and terminates `ncurses` on any exit path (SIGINT or `q`).
- **Fallbacks**: prints `"N/A"` for unknown IP/port values and suppresses kernel threads.
- **Error messaging**: when attachment fails, prompts users to inspect `bpftool feature`.
- **Helper scripts**: `verify_capture.sh` and `simple_anomaly.sh` assist with validation.

## Complement to the CPU Monitor

| Component                | CPU Monitor                                 | Network Monitor                                         |
|--------------------------|----------------------------------------------|---------------------------------------------------------|
| Primary metric           | CPU percentage                               | Bandwidth (bytes/s)                                     |
| State structures         | `pid_entry` with accumulated times           | `traffic_entry` with bytes, rates, and anomaly scores   |
| Additional inference     | None                                         | Application heuristics based on process name            |
| UI highlights            | CPU utilisation bars                         | High-bandwidth alerts                                   |
| Cleanup policy           | Remove orphan PIDs                           | Drop entries with stale timestamps                      |

The frontend reuses proven patterns from the CPU Monitor but adapts the pipeline to focus on network traffic, giving Honey developers a complementary reference implementation.

