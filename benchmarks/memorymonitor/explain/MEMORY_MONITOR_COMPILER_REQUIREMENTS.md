# Memory Monitor - Honey Compiler Enhancement Requirements

## Overview

This document outlines the **additional** enhancements required for the Honey Potion compiler to enable the creation of an Elixir-based memory monitor that matches the functionality and complexity of the C implementation in `/benchmarks/memorymonitor/`. 

**Note**: This document is **complementary** to `COMPILER_ENHANCEMENT_REQUIREMENTS.md` and focuses only on features **specific to memory monitoring** that are not covered in the general CPU monitor requirements.

## Prerequisites

This document assumes that the following features from `COMPILER_ENHANCEMENT_REQUIREMENTS.md` are already implemented:
- ✅ Multiple tracepoint handler support
- ✅ Hash map support with custom types  
- ✅ Bitwise operations support
- ✅ Advanced eBPF helper functions
- ✅ Context structure access
- ✅ Error handling and return values

## Memory Monitor Specific Requirements

### What's Missing for Memory Monitor
The compiler lacks support for:
- Ring buffer maps for event streaming
- Complex data structures (structs) with string fields
- Map iteration and cleanup operations
- Ring buffer operations (reserve, submit)

## Required Enhancements

### 1. Ring Buffer Map Support

**Current Limitation**: No support for ring buffer maps.

**Required Enhancement**: Support for ring buffer maps for high-throughput event streaming.

**Example of Desired Elixir Code**:
```elixir
defmodule MemoryMonitorFull do
  # Ring buffer for event streaming
  defmap(:mem_events, :bpf_ringbuf, [
    max_entries: 262144  # 256KB buffer
  ])
end
```

**Implementation Requirements**:
- Support `:bpf_ringbuf` map type
- Generate proper ring buffer operations
- Handle ring buffer reserve and submit operations

### 2. Complex Data Structures with String Fields

**Current Limitation**: No support for custom structs with string fields.

**Required Enhancement**: Support for defining and using custom data structures with string fields.

**Example of Desired Elixir Code**:
```elixir
defmodule MemoryMonitorFull do
  # Define custom structs with string fields
  defstruct :mem_event do
    field(:timestamp, :u64)
    field(:pid, :u32)
    field(:tgid, :u32)
    field(:size, :u64)
    field(:address, :u64)
    field(:event_type, :u8)
    field(:comm, :string, size: 16)  # String field for process name
  end
end
```

**Implementation Requirements**:
- Support `defstruct` macro for custom data types
- Support string fields with fixed size
- Generate proper C struct definitions with char arrays
- Handle struct field access and modification
- Support struct initialization and assignment

### 3. Map Iteration and Cleanup Operations

**Current Limitation**: No support for map iteration or cleanup operations.

**Required Enhancement**: Support for map iteration and cleanup operations.

**Example of Desired Elixir Code**:
```elixir
def cleanup_old_entries() do
  # Iterate through map to find old entries
  Honey.BpfHelpers.bpf_map_get_next_key(:mem_stats_map, nil, current_key)
  
  # Delete old entries
  Honey.BpfHelpers.bpf_map_delete_elem(:mem_stats_map, old_key)
end
```

**Implementation Requirements**:
- Support `bpf_map_get_next_key()` for iteration
- Support `bpf_map_delete_elem()` for cleanup
- Handle map iteration patterns
- Support cleanup strategies

## Proposed GitHub Issues (Memory Monitor Specific)

### Issue #1: Ring Buffer Map Support
**Title**: "Add Support for Ring Buffer Maps"
**Priority**: High
**Description**: Add support for ring buffer maps to enable high-throughput event streaming from eBPF to user-space.

**Acceptance Criteria**:
- [ ] Support `:bpf_ringbuf` map type
- [ ] Generate proper ring buffer operations
- [ ] Handle ring buffer reserve and submit operations
- [ ] Support event streaming patterns
- [ ] Add tests for ring buffer operations
- [ ] Update documentation with examples

**Example**:
```elixir
defmap(:events, :bpf_ringbuf, [
  max_entries: 262144
])
```

### Issue #2: Complex Data Structures with String Fields
**Title**: "Support Custom Data Structures with String Fields"
**Priority**: High
**Description**: Add support for defining and using custom data structures with string fields to enable complex data modeling in eBPF programs.

**Acceptance Criteria**:
- [ ] Support `defstruct` macro for custom data types
- [ ] Support string fields with fixed size
- [ ] Generate proper C struct definitions with char arrays
- [ ] Handle struct field access and modification
- [ ] Support struct initialization and assignment
- [ ] Add tests for struct operations
- [ ] Update documentation with examples

**Example**:
```elixir
defstruct :mem_event do
  field(:timestamp, :u64)
  field(:pid, :u32)
  field(:comm, :string, size: 16)
end
```

### Issue #3: Map Iteration and Cleanup Operations
**Title**: "Support Map Iteration and Cleanup Operations"
**Priority**: Medium
**Description**: Add support for map iteration and cleanup operations to enable advanced map management.

**Acceptance Criteria**:
- [ ] Support `bpf_map_get_next_key()` for iteration
- [ ] Support `bpf_map_delete_elem()` for cleanup
- [ ] Handle map iteration patterns
- [ ] Support cleanup strategies
- [ ] Add tests for map operations
- [ ] Update documentation with examples

**Example**:
```elixir
def cleanup_old_entries() do
  Honey.BpfHelpers.bpf_map_get_next_key(:mem_stats_map, nil, current_key)
  Honey.BpfHelpers.bpf_map_delete_elem(:mem_stats_map, old_key)
end
```

## Expected Elixir Code for Memory Monitor (Using Prerequisites)

With the prerequisites from `COMPILER_ENHANCEMENT_REQUIREMENTS.md` implemented plus the memory monitor specific features, the code would look like this:

```elixir
defmodule MemoryMonitorFull do
  use Honey, license: "Dual BSD/GPL"

  # Define custom structs (prerequisite: Complex Data Structures)
  defstruct :mem_stats do
    field(:total_allocated, :u64)
    field(:total_freed, :u64)
    field(:current_usage, :u64)
    field(:peak_usage, :u64)
    field(:alloc_count, :u64)
    field(:free_count, :u64)
    field(:mmap_count, :u64)
    field(:munmap_count, :u64)
    field(:last_update, :u64)
  end

  # Memory monitor specific: String fields in structs
  defstruct :mem_event do
    field(:timestamp, :u64)
    field(:pid, :u32)
    field(:tgid, :u32)
    field(:size, :u64)
    field(:address, :u64)
    field(:event_type, :u8)
    field(:comm, :string, size: 16)  # Memory monitor specific
  end

  # Prerequisite: Hash maps with custom types
  defmap(:mem_stats_map, :bpf_hash, [
    max_entries: 10240,
    key_type: :u32,
    value_type: :mem_stats_struct
  ])
  
  defmap(:active_allocs, :bpf_hash, [
    max_entries: 10240,
    key_type: :u64,
    value_type: :u64
  ])
  
  # Memory monitor specific: Ring buffer maps
  defmap(:mem_events, :bpf_ringbuf, [
    max_entries: 262144
  ])

  # Prerequisite: Multiple tracepoint handlers
  @sec "tracepoint/syscalls/sys_enter_mmap"
  def on_mmap_enter(ctx) do
    # Prerequisite: Bitwise operations and helper functions
    pid_tgid = Honey.BpfHelpers.bpf_get_current_pid_tgid()
    pid = pid_tgid & 0xFFFFFFFF
    tgid = pid_tgid >> 32
    
    # Prerequisite: Context structure access
    length = ctx.args[1]
    
    if length >= 1024 do
      update_mem_stats(pid, length, 2)
      
      # Memory monitor specific: Ring buffer operations
      event = Honey.BpfHelpers.bpf_ringbuf_reserve(:mem_events, 64, 0)
      if event != nil do
        event.timestamp = Honey.BpfHelpers.bpf_ktime_get_ns()
        event.pid = pid
        event.tgid = tgid
        event.size = length
        event.address = 0
        event.event_type = 2
        Honey.BpfHelpers.bpf_get_current_comm(event.comm, 16)
        Honey.BpfHelpers.bpf_ringbuf_submit(event, 0)
      end
    end
    
    0
  end

  @sec "tracepoint/syscalls/sys_enter_munmap"
  def on_munmap_enter(ctx) do
    pid_tgid = Honey.BpfHelpers.bpf_get_current_pid_tgid()
    pid = pid_tgid & 0xFFFFFFFF
    tgid = pid_tgid >> 32
    length = ctx.args[1]
    
    update_mem_stats(pid, length, 3)
    
    event = Honey.BpfHelpers.bpf_ringbuf_reserve(:mem_events, 64, 0)
    if event != nil do
      event.timestamp = Honey.BpfHelpers.bpf_ktime_get_ns()
      event.pid = pid
      event.tgid = tgid
      event.size = length
      event.address = 0
      event.event_type = 3
      Honey.BpfHelpers.bpf_get_current_comm(event.comm, 16)
      Honey.BpfHelpers.bpf_ringbuf_submit(event, 0)
    end
    
    0
  end

  @sec "tracepoint/syscalls/sys_enter_brk"
  def on_brk_enter(ctx) do
    pid_tgid = Honey.BpfHelpers.bpf_get_current_pid_tgid()
    pid = pid_tgid & 0xFFFFFFFF
    tgid = pid_tgid >> 32
    addr = ctx.args[0]
    
    event = Honey.BpfHelpers.bpf_ringbuf_reserve(:mem_events, 64, 0)
    if event != nil do
      event.timestamp = Honey.BpfHelpers.bpf_ktime_get_ns()
      event.pid = pid
      event.tgid = tgid
      event.size = 0
      event.address = addr
      event.event_type = 4
      Honey.BpfHelpers.bpf_get_current_comm(event.comm, 16)
      Honey.BpfHelpers.bpf_ringbuf_submit(event, 0)
    end
    
    0
  end

  defp update_mem_stats(pid, size, event_type) do
    stats = Honey.BpfHelpers.bpf_map_lookup_elem(:mem_stats_map, pid)
    if stats == nil do
      new_stats = %mem_stats{
        last_update: Honey.BpfHelpers.bpf_ktime_get_ns()
      }
      Honey.BpfHelpers.bpf_map_update_elem(:mem_stats_map, pid, new_stats, :bpf_noexist)
      stats = Honey.BpfHelpers.bpf_map_lookup_elem(:mem_stats_map, pid)
      if stats == nil do
        return
      end
    end

    stats.last_update = Honey.BpfHelpers.bpf_ktime_get_ns()

    case event_type do
      0 ->  # alloc
        stats.total_allocated = stats.total_allocated + size
        stats.current_usage = stats.current_usage + size
        stats.alloc_count = stats.alloc_count + 1
        if stats.current_usage > stats.peak_usage do
          stats.peak_usage = stats.current_usage
        end
      1 ->  # free
        if stats.current_usage >= size do
          stats.current_usage = stats.current_usage - size
        end
        stats.total_freed = stats.total_freed + size
        stats.free_count = stats.free_count + 1
      2 ->  # mmap
        stats.mmap_count = stats.mmap_count + 1
        stats.current_usage = stats.current_usage + size
        if stats.current_usage > stats.peak_usage do
          stats.peak_usage = stats.current_usage
        end
      3 ->  # munmap
        if stats.current_usage >= size do
          stats.current_usage = stats.current_usage - size
        end
        stats.munmap_count = stats.munmap_count + 1
    end

    Honey.BpfHelpers.bpf_map_update_elem(:mem_stats_map, pid, stats, :bpf_any)
  end
end
```

## Conclusion

This document focuses on the **additional** features needed specifically for memory monitoring beyond the general eBPF capabilities outlined in `COMPILER_ENHANCEMENT_REQUIREMENTS.md`. The memory monitor requires:

**Memory Monitor Specific Features**:
1. **Ring Buffer Maps**: For high-throughput event streaming
2. **String Fields in Structs**: For process names in events
3. **Map Iteration/Cleanup**: For memory management

**Prerequisites from General Requirements**:
- Multiple tracepoint handlers (mmap, munmap, brk)
- Hash maps with custom types
- Bitwise operations for PID extraction
- Advanced helper functions
- Context structure access
- Error handling and return values

This complementary approach ensures no duplication while providing complete coverage for both CPU and memory monitoring use cases.
