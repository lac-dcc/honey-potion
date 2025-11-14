# Logger Support in Honey Potion

Honey Potion now supports Elixir's standard `Logger` module for logging in eBPF programs. This provides a more familiar and organized way to handle logging compared to raw `bpf_printk` calls.

## Supported Logger Functions

The following Logger functions are supported:

- `Logger.debug/1` and `Logger.debug/2`
- `Logger.info/1` and `Logger.info/2`
- `Logger.warn/1` and `Logger.warn/2` (deprecated, use `warning`)
- `Logger.warning/1` and `Logger.warning/2`
- `Logger.error/1` and `Logger.error/2`

**Note**: Both `Logger.warn` and `Logger.warning` are supported for compatibility, but `Logger.warning` is preferred as `Logger.warn` is deprecated in newer Elixir versions.

## Usage Examples

### Basic Logging

```elixir
defmodule MyBPF do
  def main(ctx) do
    Logger.info("Program started")
    Logger.debug("Debug information")
    Logger.warning("Warning message")  # Preferred
    Logger.warn("Warning message")     # Deprecated but supported
    Logger.error("Error occurred")
    
    Honey.XDP.pass()
  end
end
```

### Logging with Variables

```elixir
defmodule MyBPF do
  def main(ctx) do
    pid = Honey.BpfHelpers.bpf_get_current_pid_tgid()
    
    Logger.info("Processing PID: %d", pid)
    Logger.debug("Current context: %p", ctx)
    
    if pid > 1000 do
      Logger.warning("High PID detected: %d", pid)
    end
    
    Honey.XDP.pass()
  end
end
```

### Log Levels and Prefixes

Each Logger function automatically adds an appropriate prefix to the output:

- `Logger.debug("message")` → `"[DEBUG] message"`
- `Logger.info("message")` → `"[INFO] message"`
- `Logger.warn("message")` → `"[WARN] message"` (deprecated)
- `Logger.warning("message")` → `"[WARN] message"` (preferred)
- `Logger.error("message")` → `"[ERROR] message"`

## Generated C Code

The Logger calls are translated to `bpf_printk` calls with prefixes. For example:

```elixir
Logger.info("Processing PID: %d", pid)
```

Becomes:

```c
bpf_printk("[INFO] Processing PID: %d", helper_var_123);
```

## Advantages over bpf_printk

1. **Familiar Syntax**: Uses Elixir's standard Logger, familiar to Elixir developers
2. **Automatic Prefixes**: Log levels are automatically prefixed to messages
3. **Better Organization**: Different log levels help categorize output
4. **Code Clarity**: Intent is clearer than raw bpf_printk calls

## Migration from bpf_printk

Old code:
```elixir
Honey.BpfHelpers.bpf_printk("Debug: PID = %d", pid)
Honey.BpfHelpers.bpf_printk("Error: Invalid packet")
```

New code:
```elixir
Logger.debug("PID = %d", pid)
Logger.error("Invalid packet")
```

## Limitations

1. **String Interpolation**: Elixir's string interpolation syntax (`"PID: #{pid}"`) is not yet supported. Use format strings instead: `"PID: %d", pid`.

2. **Complex Data Structures**: Only basic types (integers, strings) are supported as arguments.

3. **Logger Configuration**: eBPF context doesn't support Logger backends, filters, or other configuration options.

4. **Metadata**: Logger metadata and structured logging features are not available in eBPF context.

## Best Practices

1. **Use Appropriate Levels**:
   - `debug`: Detailed diagnostic information
   - `info`: General operational messages
   - `warning`: Warning conditions that don't stop operation (preferred)
   - `warn`: Warning conditions (deprecated, use `warning`)
   - `error`: Error conditions

2. **Format Strings**: Use printf-style format strings for variables:
   ```elixir
   # Good
   Logger.info("PID: %d, Port: %d", pid, port)
   
   # Not yet supported
   Logger.info("PID: #{pid}, Port: #{port}")
   ```

3. **Performance**: Remember that logging in eBPF has performance implications. Use appropriate log levels and avoid excessive logging in hot paths.

## Complete Example

See `examples/logger_example.ex` for a complete working example demonstrating Logger usage in an eBPF program.