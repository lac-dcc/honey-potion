# Honey Compiler Enhancement Requirements for the Network Monitor Benchmark

## Overview

The Network Monitor benchmark significantly expands the feature set required from the Honey compiler to generate equivalent eBPF programs. The C implementation combines multiple syscall tracepoints, safe reads from user-space structures, and extensive use of composite map keys. This document highlights the gaps observed in the current compiler and the enhancements needed to enable a faithful port of the code.

## Newly Observed Challenges

### 1. Composite keys and aligned structures

**Current state**: Honey provides limited support for simple structs as map values but cannot emit composite keys with explicit alignment.

**Requirement**:
- Define structs with multiple fields (`pid`, `protocol`, `port`, `ip`) to serve as `BPF_MAP_TYPE_HASH` keys.
- Guarantee padding as required by the verifier while preserving the C layout.
- Allow zero-initialised declarations (`struct traffic_key key = {};`).

### 2. Safe user-space memory reads

**Current state**: There is no direct support for helpers such as `bpf_probe_read_user()` or `BPF_CORE_READ()` to traverse pointers provided through syscalls.

**Requirement**:
- Generate `bpf_probe_read_user()` calls with error handling.
- Support `BPF_CORE_READ` to access fields such as `msg->msg_iter.count`.
- Abstract struct offsets (`sockaddr_in`, `msghdr`, `iov_iter`) without upsetting the verifier.

### 3. Syscall argument handling

**Current state**: The compiler does not expose `trace_event_raw_sys_enter` with typed access to the `args[]` array.

**Requirement**:
- Support tracepoints `sys_enter_sendto`, `sys_enter_recvfrom`, `sys_enter_sendmsg`, `sys_enter_recvmsg`.
- Generate code to extract typed arguments (addresses, lengths, flags).
- Handle 64→32-bit shifts to obtain the PID via `bpf_get_current_pid_tgid()`.

### 4. Networking helpers and endianness conversion

**Current state**: There is no support for utilities like `ntohs()` or protocol masks.

**Requirement**:
- Emit inline helpers `ntohs`/`htonl`.
- Provide protocol constants (`IPPROTO_TCP`, `IPPROTO_UDP`, etc.).
- Enable bitwise operations to interpret network headers.

### 5. Complementary maps for aggregation

**Current state**: Only basic map types are supported.

**Requirement**:
- `traffic_map`: hash map keyed by a composite struct.
- `protocol_totals`: hash map keyed by a single byte.
- `anomaly_map`: hash map used to communicate with user space.
- `pid_stats`: aggregated statistics by PID.

### 6. Return handling and early exits

**Current state**: Generated control flow is simple and lacks conditional early returns.

**Requirement**:
- Emit `if (...) return 0;` blocks for invalid conditions.
- Keep the code compact to satisfy verifier limits.
- Allow multiple `return` statements per handler.

## Suggested Honey Repository Issues

### Issue #1 — Support composite map keys
**Title**: "Generate aligned composite structs for eBPF map keys"  
**Goal**: Allow Honey modules to declare aligned structs used as hash map keys.  
**Acceptance criteria**:
- [ ] Define structs with multiple primitive fields.
- [ ] Ensure zero-initialisation (`memset`) when required.
- [ ] Use structs in `bpf_map_lookup_elem` / `bpf_map_update_elem`.

### Issue #2 — User-space read helpers
**Title**: "Expose `bpf_probe_read_user` and `BPF_CORE_READ` helpers"  
**Goal**: Enable safe reads of data pointed to by syscall arguments.  
**Acceptance criteria**:
- [ ] Provide a DSL entry such as `Honey.BpfHelpers.probe_read_user(ptr, size)`.
- [ ] Generate `BPF_CORE_READ` calls for nested fields.
- [ ] Return optional `nil` for read failures.

### Issue #3 — Networking syscall bindings
**Title**: "Map `sys_enter_send*` and `sys_enter_recv*` tracepoints"  
**Goal**: Allow Honey modules to attach handlers to networking syscalls.  
**Acceptance criteria**:
- [ ] Generate function signatures taking `struct trace_event_raw_sys_enter`.
- [ ] Provide typed access to `ctx.args[n]`.
- [ ] Validate loading on kernel 5.15+.

### Issue #4 — Endianness conversion helpers
**Title**: "Provide byte-order utilities for eBPF programs"  
**Goal**: Avoid reimplementing `ntohs`/`htonl` manually.  
**Acceptance criteria**:
- [ ] Offer `Honey.Net.htons/htonl/ntohs/ntohl`.
- [ ] Emit inline code without extra helper calls.
- [ ] Document usage within networking benchmarks.

### Issue #5 — Auxiliary maps for anomaly detection
**Title**: "Support multiple correlated maps keyed by PID and protocol"  
**Goal**: Facilitate benchmarks that cross-reference PID ↔ protocol ↔ anomaly data.  
**Acceptance criteria**:
- [ ] Declare multiple maps within one module.
- [ ] Allow coordinated read/write operations in a single handler.
- [ ] Generate reusable helper functions for statistics updates.

### Issue #6 — Early returns and richer control flow
**Title**: "Improve conditional `return` generation in eBPF handlers"  
**Goal**: Reproduce the short-circuit logic found in production programs.  
**Acceptance criteria**:
- [ ] Support multiple `return` statements per function.
- [ ] Translate simple `if` conditions to early exits faithfully.
- [ ] Add tests covering nested checks (`if (cond) return 0;`).

## Conclusion

With these enhancements, the Honey compiler would be able to generate a network monitor comparable to the C implementation, covering syscall capture, structure parsing, statistics aggregation, and efficient communication with user space.

