
# Quickstart

This guide provides a high-level overview for developers new to eBPF and Honey Potion. For more details on eBPF, see the [official eBPF documentation](https://ebpf.io/what-is-ebpf/).

---

## 1. Project Setup

### Create a New Elixir Project

```sh
mix new hello_world
cd hello_world
```

### Compilation Dependencies

Before compiling, ensure the following system dependencies are installed (Ubuntu package names; equivalents exist for other distributions):

- Erlang & Elixir (for running Honey Potion)
- libbpf (version 1.1)
- gcc-multilib (for certain C libraries)
- make
- llvm (provides `llc`)
- clang (required for compilation)
- bpftool (used for skeleton generation)

All these tools must be available in your `$PATH`.

### Add Honey Potion as a Dependency

Edit your `mix.exs`:

```elixir
defp deps do
	[
		{:honey, git: "https://github.com/lac-dcc/honey-potion/", submodules: true}
	]
end
```

Fetch dependencies:

```sh
mix deps.get
```

---

## 2. Writing a Minimal eBPF Program

Create `lib/hello_world.ex`:

```elixir
defmodule HelloWorld do
	use Honey, license: "Dual BSD/GPL"

	@sec "tracepoint/syscalls/sys_enter_write"
	def main(_ctx) do
		Honey.BpfHelpers.bpf_printk(["Hello World"])
	end
end
```

- `use Honey` enables Elixir-to-eBPF translation.
- `@sec` defines the eBPF program type and attach point.
- `main/1` is the entry point and must return an integer.

---

## 3. Compiling and Running

```sh
mix format
mix compile

cd bin
sudo ./hello_world
```

To view kernel output:

```sh
sudo cat /sys/kernel/debug/tracing/trace_pipe
```

---

## 4. eBPF Concepts and Honey Potion

### What is eBPF?

eBPF (extended Berkeley Packet Filter) is a Linux technology for running sandboxed programs in the kernel. It is widely used for tracing, monitoring, networking, and security. See the [official eBPF documentation](https://ebpf.io/what-is-ebpf/) for a comprehensive introduction.

### Types of eBPF Programs

- **Tracepoints**: Attach to kernel events (e.g., syscalls, scheduler events)
- **Kprobes/Kretprobes**: Attach to function entry/exit in the kernel
- **XDP**: High-performance packet processing at the network driver level
- **Socket filters**: Attach to sockets for packet filtering
- **Perf events**: Attach to performance monitoring events

Honey Potion currently focuses on tracepoints and XDP.

#### Common Tracepoints

- `tracepoint/raw_syscalls/sys_enter`: Any syscall entry
- `tracepoint/syscalls/sys_enter_<name>`: Specific syscall (e.g., `sys_enter_write`)
- `tracepoint/sched/sched_switch`: Context switches
- `xdp_md`: XDP programs (network packet processing)

Each tracepoint provides a context (`ctx`) with fields relevant to the event (e.g., syscall ID, process ID).

---

## 5. eBPF Data Structures in Honey Potion

### Maps

eBPF programs use maps to store and share data between kernel and user space. Honey Potion supports:

- Array maps: Indexed by integer keys, fixed size
- Hash maps: Key-value store, dynamic size
- Per-CPU maps: Store separate values per CPU

Define a map with:

```elixir
defmap(:my_map, :bpf_array, max_entries: 128, print: true)
```

Access maps:

```elixir
Honey.BpfHelpers.bpf_map_lookup_elem(:my_map, key)
Honey.BpfHelpers.bpf_map_update_elem(:my_map, key, value)
```

### Helper Functions

- `Honey.BpfHelpers.bpf_printk/1`: Print to the kernel trace pipe
- Other helpers for time, process info, and map operations

---

## 6. Advanced Features

### Pattern Matching

Honey Potion supports Elixir's `case`, `cond`, and `if` expressions, which are translated to eBPF-compatible C code.

### Recursion with the `fuel` Macro

eBPF does not allow unbounded recursion. Honey Potion provides the `fuel` macro to limit recursion depth, ensuring programs pass the eBPF verifier.

Example:

```elixir
def sum(a, b) do
	if b == 0 do
		a
	else
		sum(a + 1, b - 1)
	end
end

@sec "tracepoint/raw_syscalls/sys_enter"
def main(_ctx) do
	x = 100
	y = fuel 10, sum(x, 5)
	Honey.BpfHelpers.bpf_printk(["The value of y is %d", y])
end
```

In this example, `fuel 10, sum(x, 5)` allows up to 10 recursive calls. If the limit is reached, a runtime exception is triggered and the program halts.

### Exception Handling

If a runtime exception occurs (e.g., recursion limit reached), Honey Potion prints the error to the trace pipe and exits the program.

---

## 7. More Examples

See the `examples/` directory in the Honey Potion repository for:

- System call counters
- Disk and memory monitors
- Network packet filters
- Logger integration

---

For more details, consult the documentation in `docs/guides/` and the README. Honey Potion brings the power of eBPF to Elixir, making kernel programming accessible to all developers.
