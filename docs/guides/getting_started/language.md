
# Honey Potion Language Reference

Honey Potion allows you to write eBPF programs in a subset of Elixir, which is then translated to C and compiled for the Linux kernel. This document summarizes the supported language features and their translation.

## Language Overview

- Only a subset of Elixir is supported, focused on static, verifiable code suitable for eBPF.
- See the `examples/` directory for practical code samples.

## Variables and Constants

- Variables are immutable, as in Elixir. Each assignment creates a new version internally.
- Types are inferred, but all values must be representable in C. Honey uses a custom `Dynamic` type in C to support multiple Elixir types.
- Variable names in generated C code are suffixed with versioning to avoid conflicts (e.g., `x_1_`, `x_2_`).

## Control Flow: Case, Cond, If

- `case`, `cond`, and `if` expressions are supported and translated to C as a series of conditional statements.
- Only one branch is executed; the result is stored in a temporary variable and then assigned to the user variable.

## eBPF Maps

You can define eBPF maps using the `defmap` macro. Example:

```elixir
defmap(:my_map, :bpf_array, max_entries: 128, print: true, print_elem: [{"entry0", 0}, {"entry1", 1}])
```

- `:my_map` is the map name (used for lookups and updates)
- `:bpf_array` or `:bpf_hash` are supported types
- `max_entries` sets the map size
- `print` enables printing map contents
- `print_elem` customizes printed entries

### Map Operations

Use the following helpers to interact with maps:

```elixir
Honey.BpfHelpers.bpf_map_lookup_elem(:my_map, key)
Honey.BpfHelpers.bpf_map_update_elem(:my_map, key, value)
```

## BPF Helper Functions

Honey Potion exposes several BPF helper functions. The most common is:

```elixir
Honey.BpfHelpers.bpf_printk(["format string", arg1, arg2, ...])
```

This prints to `/sys/kernel/debug/tracing/trace_pipe`.

Other helpers are available for time, process info, and map operations.

## Recursion and the `fuel` Macro

eBPF does not allow unbounded recursion. Honey Potion supports recursion by requiring a maximum recursion depth, enforced by the `fuel` macro.

Example:

```elixir
def sum(a, b) do
  if b == 0 do
    a
  else
    sum(a + 1, b - 1)
  end
end

@sec "tracepoint/syscalls/sys_enter_kill"
def main(_ctx) do
  x = 100
  y = fuel 10, sum(x, 5)
  Honey.BpfHelpers.bpf_printk(["The value of y is %d", y])
end
```

Here, `fuel 10, sum(x, 5)` allows up to 10 recursive calls. If the limit is reached, a runtime exception is triggered and the program halts.

## Logger Support

You can use Elixir's `Logger` macros in Honey Potion. Logger calls are translated to `bpf_printk` with log level prefixes. Example:

```elixir
require Logger

def main(_ctx) do
  Logger.info("Program started")
  Logger.warning("Warning message")
  Logger.error("Error occurred")
end
```

## Boilerplate and Compilation

Honey Potion automatically adds the necessary C boilerplate for eBPF programs. You do not need to manage includes, defines, or runtime helpers manually.

## Limitations and Notes

- Only a subset of Elixir is supported (no dynamic code, no macros except those provided by Honey)
- All code must be statically analyzable and verifiable by the eBPF kernel verifier
- Pattern matching is supported in function heads and case/cond/if
- No floating point or complex types
