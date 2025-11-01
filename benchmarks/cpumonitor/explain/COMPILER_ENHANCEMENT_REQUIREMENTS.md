# Honey Compiler Enhancement Requirements for CPU Monitor Benchmark

## Overview

This document outlines the necessary enhancements to the Honey Potion compiler to enable the creation of eBPF programs that match the functionality and complexity of the C CPU monitor benchmark. The current Honey compiler has several limitations that prevent it from generating equivalent eBPF code.

## Current State Analysis

### What Works Today
The Honey compiler currently supports:
- Basic eBPF map operations (`bpf_map_lookup_elem`, `bpf_map_update_elem`)
- Single tracepoint attachment per module
- Simple arithmetic and conditional operations
- Basic data types (integers, arrays)
- Single entry point functions (`main/1`)

### What's Missing
The compiler lacks support for:
- Multiple tracepoint handlers per module
- Complex data structures and structs
- Bitwise operations and bit shifting
- Multiple map types beyond basic arrays
- Advanced eBPF helper functions
- Proper error handling and return value management

## Required Enhancements

### 1. Multiple Tracepoint Support

**Current Limitation**: Only one `@sec` attribute and `main/1` function per module.

**Required Enhancement**: Support for multiple tracepoint handlers in a single module.

**Example of Desired Elixir Code**:
```elixir
defmodule CpuMonitorFull do
  use Honey, license: "Dual BSD/GPL"

  # Multiple tracepoint handlers
  @sec "tracepoint/sched/sched_switch"
  def on_sched_switch(ctx) do
    # Handle process scheduling
  end

  @sec "tracepoint/raw_syscalls/sys_enter"
  def on_sys_enter(ctx) do
    # Handle syscall entry
  end

  @sec "tracepoint/raw_syscalls/sys_exit"
  def on_sys_exit(ctx) do
    # Handle syscall exit
  end
end
```

**Implementation Requirements**:
- Allow multiple `@sec` attributes with different tracepoint types
- Support multiple function definitions with different names
- Generate separate eBPF programs for each tracepoint
- Handle program loading and attachment for multiple programs

### 2. Enhanced Map Type Support

**Current Limitation**: Limited to basic `:bpf_array` maps with simple key-value types.

**Required Enhancement**: Support for hash maps and complex data structures.

**Example of Desired Elixir Code**:
```elixir
defmodule CpuMonitorFull do
  # Hash maps for efficient PID-based lookups
  defmap(:start_time, :bpf_hash, [
    max_entries: 10240,
    key_type: :u32,      # PID
    value_type: :u64     # Timestamp
  ])
  
  defmap(:kernel_time, :bpf_hash, [
    max_entries: 10240,
    key_type: :u32,      # PID
    value_type: :u64     # Cumulative kernel time
  ])
  
  defmap(:user_time, :bpf_hash, [
    max_entries: 10240,
    key_type: :u32,      # PID
    value_type: :u64     # Cumulative user time
  ])
end
```

**Implementation Requirements**:
- Support `:bpf_hash` map type
- Allow custom key and value types
- Generate proper C struct definitions for maps
- Handle map creation with correct parameters

### 3. Bitwise Operations Support

**Current Limitation**: No support for bitwise operations like `>>` and `<<`.

**Required Enhancement**: Support for bitwise operations commonly used in eBPF programs.

**Example of Desired Elixir Code**:
```elixir
def on_sys_enter(ctx) do
  # Extract PID from bpf_get_current_pid_tgid()
  pid_tgid = Honey.BpfHelpers.bpf_get_current_pid_tgid()
  pid = pid_tgid >>> 32  # Right shift to get PID
  
  # Other operations
end
```

**Implementation Requirements**:
- Support bitwise shift operations (`>>>`, `<<<`)
- Support bitwise AND/OR operations (`&&&`, `|||`)
- Generate proper C bitwise operations
- Handle integer overflow and underflow

### 4. Advanced eBPF Helper Functions

**Current Limitation**: Limited set of helper functions available.

**Required Enhancement**: Support for additional eBPF helper functions.

**Example of Desired Elixir Code**:
```elixir
def on_sys_enter(ctx) do
  # Get current PID and TID
  pid_tgid = Honey.BpfHelpers.bpf_get_current_pid_tgid()
  pid = pid_tgid >>> 32
  
  # Get current timestamp
  ts = Honey.BpfHelpers.bpf_ktime_get_ns()
  
  # Update map with current timestamp
  Honey.BpfHelpers.bpf_map_update_elem(:syscall_start, pid, ts, :bpf_any)
end
```

**Implementation Requirements**:
- Support `bpf_get_current_pid_tgid()`
- Support `bpf_ktime_get_ns()`
- Support map update flags (`:bpf_any`, `:bpf_noexist`, `:bpf_exist`)
- Support map delete operations
- Support `bpf_printk()` for debugging

### 5. Complex Data Structures and Context Handling

**Current Limitation**: Limited context structure access and no support for complex data types.

**Required Enhancement**: Support for accessing tracepoint context structures.

**Example of Desired Elixir Code**:
```elixir
def on_sched_switch(ctx) do
  # Access context fields
  prev_pid = ctx.prev_pid
  next_pid = ctx.next_pid
  
  # Use context data
  ts = Honey.BpfHelpers.bpf_ktime_get_ns()
  
  # Process previous process
  if prev_pid > 0 do
    start = Honey.BpfHelpers.bpf_map_lookup_elem(:start_time, prev_pid)
    if start != nil do
      delta = ts - start
      # Calculate and update times
    end
  end
  
  # Start timing next process
  Honey.BpfHelpers.bpf_map_update_elem(:start_time, next_pid, ts, :bpf_any)
end
```

**Implementation Requirements**:
- Support context field access (`ctx.field_name`)
- Handle different context types for different tracepoints
- Generate proper C struct access patterns
- Support nil checks and error handling

### 6. Error Handling and Return Values

**Current Limitation**: Limited error handling and return value management.

**Required Enhancement**: Proper error handling and return value support.

**Example of Desired Elixir Code**:
```elixir
def on_sched_switch(ctx) do
  ts = Honey.BpfHelpers.bpf_ktime_get_ns()
  prev_pid = ctx.prev_pid
  next_pid = ctx.next_pid

  # Process previous process with error handling
  if prev_pid > 0 do
    start = Honey.BpfHelpers.bpf_map_lookup_elem(:start_time, prev_pid)
    if start != nil do
      delta = ts - start
      
      # Update kernel time
      kernel_result = Honey.BpfHelpers.bpf_map_lookup_elem(:kernel_time, prev_pid)
      if kernel_result != nil do
        Honey.BpfHelpers.bpf_map_update_elem(:kernel_time, prev_pid, kernel_result + delta, :bpf_any)
      else
        Honey.BpfHelpers.bpf_map_update_elem(:kernel_time, prev_pid, delta, :bpf_any)
      end
      
      # Clean up start time
      Honey.BpfHelpers.bpf_map_delete_elem(:start_time, prev_pid)
    end
  end
  
  # Start timing next process
  Honey.BpfHelpers.bpf_map_update_elem(:start_time, next_pid, ts, :bpf_any)
  
  # Return success
  0
end
```

**Implementation Requirements**:
- Support conditional error handling
- Support map operation result checking
- Support proper return values
- Handle nil/error cases gracefully

## Proposed GitHub Issues

### Issue #1: Multiple Tracepoint Handler Support
**Title**: "Support Multiple Tracepoint Handlers in Single Module"
**Priority**: High
**Description**: Allow multiple `@sec` attributes and function definitions per module to support complex eBPF programs that need to attach to multiple tracepoints.

**Acceptance Criteria**:
- [ ] Support multiple `@sec` attributes with different tracepoint types
- [ ] Allow multiple function definitions with different names
- [ ] Generate separate eBPF programs for each tracepoint
- [ ] Handle program loading and attachment for multiple programs
- [ ] Update documentation with examples

**Example**:
```elixir
defmodule MultiTracepoint do
  use Honey, license: "Dual BSD/GPL"
  
  @sec "tracepoint/sched/sched_switch"
  def on_sched_switch(ctx) do
    # Implementation
  end
  
  @sec "tracepoint/raw_syscalls/sys_enter"
  def on_sys_enter(ctx) do
    # Implementation
  end
end
```

### Issue #2: Enhanced Map Type Support
**Title**: "Support Hash Maps and Complex Map Types"
**Priority**: High
**Description**: Add support for hash maps and complex data structures to enable efficient PID-based lookups and data storage.

**Acceptance Criteria**:
- [ ] Support `:bpf_hash` map type
- [ ] Allow custom key and value types
- [ ] Generate proper C struct definitions for maps
- [ ] Handle map creation with correct parameters
- [ ] Support map delete operations
- [ ] Update documentation with examples

**Example**:
```elixir
defmap(:process_data, :bpf_hash, [
  max_entries: 10240,
  key_type: :u32,
  value_type: :u64
])
```

### Issue #3: Bitwise Operations Support
**Title**: "Add Support for Bitwise Operations"
**Priority**: Medium
**Description**: Add support for bitwise operations commonly used in eBPF programs, such as bit shifting and bitwise AND/OR operations.

**Acceptance Criteria**:
- [ ] Support bitwise shift operations (`>>>`, `<<<`)
- [ ] Support bitwise AND/OR operations (`&&&`, `|||`)
- [ ] Generate proper C bitwise operations
- [ ] Handle integer overflow and underflow
- [ ] Add tests for bitwise operations
- [ ] Update documentation with examples

**Example**:
```elixir
def extract_pid(pid_tgid) do
  pid_tgid >>> 32
end
```

### Issue #4: Advanced eBPF Helper Functions
**Title**: "Expand eBPF Helper Function Support"
**Priority**: High
**Description**: Add support for additional eBPF helper functions commonly used in complex eBPF programs.

**Acceptance Criteria**:
- [ ] Support `bpf_get_current_pid_tgid()`
- [ ] Support `bpf_ktime_get_ns()`
- [ ] Support map update flags (`:bpf_any`, `:bpf_noexist`, `:bpf_exist`)
- [ ] Support map delete operations
- [ ] Support `bpf_printk()` for debugging
- [ ] Add tests for helper functions
- [ ] Update documentation with examples

**Example**:
```elixir
def get_current_pid() do
  pid_tgid = Honey.BpfHelpers.bpf_get_current_pid_tgid()
  pid_tgid >>> 32
end
```

### Issue #5: Context Structure Access
**Title**: "Support Tracepoint Context Structure Access"
**Priority**: High
**Description**: Enable access to tracepoint context structures to read event-specific data.

**Acceptance Criteria**:
- [ ] Support context field access (`ctx.field_name`)
- [ ] Handle different context types for different tracepoints
- [ ] Generate proper C struct access patterns
- [ ] Support nil checks and error handling
- [ ] Add tests for context access
- [ ] Update documentation with examples

**Example**:
```elixir
def on_sched_switch(ctx) do
  prev_pid = ctx.prev_pid
  next_pid = ctx.next_pid
  # Use context data
end
```

### Issue #6: Error Handling and Return Values
**Title**: "Improve Error Handling and Return Value Support"
**Priority**: Medium
**Description**: Enhance error handling capabilities and return value management for eBPF programs.

**Acceptance Criteria**:
- [ ] Support conditional error handling
- [ ] Support map operation result checking
- [ ] Support proper return values
- [ ] Handle nil/error cases gracefully
- [ ] Add tests for error handling
- [ ] Update documentation with examples

**Example**:
```elixir
def safe_map_update(map, key, value) do
  result = Honey.BpfHelpers.bpf_map_lookup_elem(map, key)
  if result != nil do
    Honey.BpfHelpers.bpf_map_update_elem(map, key, result + value, :bpf_any)
  else
    Honey.BpfHelpers.bpf_map_update_elem(map, key, value, :bpf_any)
  end
end
```

### Issue #7: Compiler Error Messages
**Title**: "Improve Compiler Error Messages and Diagnostics"
**Priority**: Low
**Description**: Enhance compiler error messages to provide better debugging information for developers.

**Acceptance Criteria**:
- [ ] Provide clear error messages for unsupported operations
- [ ] Add line number information to errors
- [ ] Suggest alternatives for unsupported features
- [ ] Add warning messages for potential issues
- [ ] Update documentation with troubleshooting guide

### Issue #8: Documentation and Examples
**Title**: "Expand Documentation and Examples"
**Priority**: Medium
**Description**: Create comprehensive documentation and examples for advanced eBPF programming with Honey.

**Acceptance Criteria**:
- [ ] Create advanced programming guide
- [ ] Add complex example programs
- [ ] Document best practices
- [ ] Create troubleshooting guide
- [ ] Add performance optimization tips

## Expected Elixir Code for CPU Monitor

With all enhancements implemented, the CPU monitor in Elixir would look like this:

```elixir
defmodule CpuMonitorFull do
  use Honey, license: "Dual BSD/GPL"

  # Hash maps for efficient PID-based lookups
  defmap(:start_time, :bpf_hash, [
    max_entries: 10240,
    key_type: :u32,
    value_type: :u64
  ])
  
  defmap(:kernel_time, :bpf_hash, [
    max_entries: 10240,
    key_type: :u32,
    value_type: :u64
  ])
  
  defmap(:user_time, :bpf_hash, [
    max_entries: 10240,
    key_type: :u32,
    value_type: :u64
  ])
  
  defmap(:syscall_start, :bpf_hash, [
    max_entries: 10240,
    key_type: :u32,
    value_type: :u64
  ])
  
  defmap(:run_kernel_time, :bpf_hash, [
    max_entries: 10240,
    key_type: :u32,
    value_type: :u64
  ])

  @sec "tracepoint/sched/sched_switch"
  def on_sched_switch(ctx) do
    ts = Honey.BpfHelpers.bpf_ktime_get_ns()
    prev_pid = ctx.prev_pid
    next_pid = ctx.next_pid

    # Process previous process
    if prev_pid > 0 do
      start = Honey.BpfHelpers.bpf_map_lookup_elem(:start_time, prev_pid)
      if start != nil do
        delta = ts - start

        # Get kernel time for this run
        ktime = 0
        kstart = Honey.BpfHelpers.bpf_map_lookup_elem(:run_kernel_time, prev_pid)
        if kstart != nil do
          ktime = kstart
          Honey.BpfHelpers.bpf_map_delete_elem(:run_kernel_time, prev_pid)
        end

        # Update user time = delta - time spent in syscalls
        if ktime < delta do
          utime = delta - ktime
          ut = Honey.BpfHelpers.bpf_map_lookup_elem(:user_time, prev_pid)
          if ut != nil do
            Honey.BpfHelpers.bpf_map_update_elem(:user_time, prev_pid, ut + utime, :bpf_any)
          else
            Honey.BpfHelpers.bpf_map_update_elem(:user_time, prev_pid, utime, :bpf_any)
          end
        end

        # Add kernel time to total kernel time
        if ktime > 0 do
          kt = Honey.BpfHelpers.bpf_map_lookup_elem(:kernel_time, prev_pid)
          if kt != nil do
            Honey.BpfHelpers.bpf_map_update_elem(:kernel_time, prev_pid, kt + ktime, :bpf_any)
          else
            Honey.BpfHelpers.bpf_map_update_elem(:kernel_time, prev_pid, ktime, :bpf_any)
          end
        end

        # Clean up start time
        Honey.BpfHelpers.bpf_map_delete_elem(:start_time, prev_pid)
      end
    end

    # Start timing next process
    Honey.BpfHelpers.bpf_map_update_elem(:start_time, next_pid, ts, :bpf_any)
    0
  end

  @sec "tracepoint/raw_syscalls/sys_enter"
  def on_sys_enter(ctx) do
    pid_tgid = Honey.BpfHelpers.bpf_get_current_pid_tgid()
    pid = pid_tgid >>> 32
    ts = Honey.BpfHelpers.bpf_ktime_get_ns()
    Honey.BpfHelpers.bpf_map_update_elem(:syscall_start, pid, ts, :bpf_any)
    0
  end

  @sec "tracepoint/raw_syscalls/sys_exit"
  def on_sys_exit(ctx) do
    pid_tgid = Honey.BpfHelpers.bpf_get_current_pid_tgid()
    pid = pid_tgid >>> 32
    ts = Honey.BpfHelpers.bpf_ktime_get_ns()
    
    start = Honey.BpfHelpers.bpf_map_lookup_elem(:syscall_start, pid)
    if start != nil do
      delta = ts - start
      
      # Track kernel time for current run
      k = Honey.BpfHelpers.bpf_map_lookup_elem(:run_kernel_time, pid)
      if k != nil do
        Honey.BpfHelpers.bpf_map_update_elem(:run_kernel_time, pid, k + delta, :bpf_any)
      else
        Honey.BpfHelpers.bpf_map_update_elem(:run_kernel_time, pid, delta, :bpf_any)
      end
      
      # Clean up syscall start time
      Honey.BpfHelpers.bpf_map_delete_elem(:syscall_start, pid)
    end
    0
  end
end
```

## Conclusion

With these enhancements, developers would be able to write complex eBPF programs in Elixir that rival the capabilities of traditional C-based eBPF development, while benefiting from Elixir's expressive syntax and functional programming paradigms.
