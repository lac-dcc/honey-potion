# Network Monitor - System Integration

## Overview

The Network Monitor couples eBPF data collection with user-space processing and presentation. The integration ensures that traffic statistics are grouped by process, protocol, and port, with near-real-time anomaly detection. This document describes how the components interact and the design choices that deliver robustness.

## Data Flow

1. **Network syscalls occur** → `sys_enter_*` tracepoints trigger the eBPF handlers.
2. **Maps are updated** → `traffic_map`, `pid_stats`, `protocol_totals`, and `anomaly_map` receive fresh counters.
3. **User-space polling** → roughly every 500 ms the frontend reads the maps and recomputes metrics.
4. **Additional processing** → `/proc/<pid>/comm` metadata and heuristic labels are combined with the raw data.
5. **ncurses UI** → results are rendered in a scrollable table with anomaly highlights.

## Communication Channels

### `traffic_map`
```c
struct traffic_key key;
struct traffic_stats stats;

// Kernel: update
bpf_map_update_elem(&traffic_map, &key, &stats, BPF_ANY);

// User space: iterate
while (bpf_map_get_next_key(traffic_fd, &cur, &next) == 0) {
    bpf_map_lookup_elem(traffic_fd, &next, &stats);
    // Convert to display structure
}
```
**Purpose**: carry detailed counters for each PID/protocol/port/IP combination.

### `protocol_totals`
```c
// Kernel: accumulate bytes per protocol
__u64 *total = bpf_map_lookup_elem(&protocol_totals, &proto);
if (total) *total += bytes;

// User space: headline display
format_bytes(total_bytes, buf, sizeof(buf));
mvprintw(2, col, "%s:%s", get_protocol_name(proto), buf);
```
**Usage**: show a global protocol summary in the header of the UI.

### `pid_stats`
```c
// Kernel: aggregate by PID
bpf_map_update_elem(&pid_stats, &pid, &stats, BPF_ANY);

// User space: merge totals
if (bpf_map_lookup_elem(pid_fd, &pid, &stats) == 0) {
    entry->bytes_sent = stats.bytes_sent;
    entry->bytes_recv = stats.bytes_recv;
}
```
**Reasoning**: provide per-PID totals used to compute overall bandwidth.

### `anomaly_map`
```c
// Kernel: placeholder value (user space computes B/s)
bpf_map_update_elem(&anomaly_map, &key, &bps, BPF_ANY);

// User space: write the actual smoothed rate
bpf_map_update_elem(anomaly_fd, &entry->key, &bandwidth, BPF_ANY);
```
**Role**: bi-directional channel storing the smoothed metric that feeds alerts.

## Synchronisation Strategy

- **Collection interval**: `update_interval_ns = 1000ms` (tunable). Balances latency and map-read overhead.
- **Cached view**: after each full read the frontend builds `view_cached`, a pointer array to traffic entries. Sorting is done once per cycle, keeping the 100 Hz renderer cheap.
- **Exit signalling**: the `exiting` flag and signal handlers ensure links are detached and the terminal restored.

## Process Handling

1. **Identification**: PIDs are sourced directly from `bpf_get_current_pid_tgid()`.
2. **Names**: resolved via `/proc/<pid>/comm`, with `"-"` fallback if the process vanished.
3. **Kernel thread filter**: entries whose names start with `kworker`, `irq/`, etc., are hidden to focus on user processes.

## User-Space Metric Computation

### Instantaneous and smoothed bandwidth
```c
double interval = (now - entry->last_seen_ns) / 1e9;
double sent_rate = delta_sent / interval;
entry->smoothed_bandwidth = alpha * sent_rate +
                            (1.0 - alpha) * entry->smoothed_bandwidth;
```
**Parameters**:
- `alpha = 0.4`: fast response with moderate smoothing.
- `interval` relies on the kernel’s `last_update_ns`, reducing dependency on user-space clocks.

### Highlighting anomalies
```c
const double threshold = 10.0 * 1024 * 1024; // 10 MB/s
bool is_anomaly = entry->smoothed_bandwidth > threshold;
```
Entries above the threshold are rendered with `A_REVERSE`, and the footer summarises the alert status (`⚠️ ALERT` vs `✓ No anomalies detected`).

## Performance

- **Kernel**: O(1) work per syscall, no loops. Maps sized for ~10K keys to avoid collisions.
- **User space**:
  - Map iteration every 1 s (configurable).
  - 100 Hz rendering keeps the UI responsive.
  - `format_bytes()` uses small static buffers to minimise allocations.

## Fault Tolerance

- **Kernel**: failures reading user memory abort the handler quietly, preserving syscall safety.
- **User space**: if `bpf_map_lookup_elem` fails, the item is skipped for that cycle; execution continues.
- **Shutdown**: on exit, links are destroyed and `ncurses` is terminated to restore the console.

## Complement to the CPU Monitor

| Aspect                | CPU Monitor                                     | Network Monitor                                        |
|-----------------------|-------------------------------------------------|--------------------------------------------------------|
| Data source           | Scheduling events and syscalls                  | Networking syscalls                                    |
| Focus                 | CPU time (user/kernel)                          | Byte volume, packet counts, anomaly detection          |
| Core structures       | PIDs with accumulated times                     | Composite key (PID + protocol + port + IP)             |
| Post-processing       | CPU percentage, EMA smoothing                   | Total bandwidth, EMA smoothing, PID-level filtering    |
| UI                    | CPU usage ranking                               | Traffic table with anomaly highlights                  |

Both benchmarks share the ncurses infrastructure and view-caching approach, yet they diverge in metrics and data handling, providing complementary examples for future Honey ports.

