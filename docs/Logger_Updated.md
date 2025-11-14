# Logger Support in Honey Potion

Honey Potion provides full support for Elixir's Logger module, automatically translating Logger calls into appropriate `bpf_printk` statements for eBPF programs.

## Features

### Basic Logging
All standard Logger functions are supported with automatic log level prefixes:
- `Logger.debug/1` → `[DEBUG]`
- `Logger.info/1` → `[INFO]`  
- `Logger.warn/1` → `[WARN]`
- `Logger.warning/1` → `[WARN]` (Elixir 1.15+ compatibility)
- `Logger.error/1` → `[ERROR]`

### String Interpolation
Logger calls support Elixir's string interpolation syntax:

```elixir
def main() do
  pid = 1234
  user_id = 5678
  
  # Simple interpolation
  Logger.info("Process PID: #{pid}")
  # Generates: bpf_printk("[INFO] Process PID: %d", pid);
  
  # Multiple variables
  Logger.debug("User #{user_id} has PID #{pid}")
  # Generates: bpf_printk("[DEBUG] User %d has PID %d", user_id, pid);
  
  # Regular strings still work
  Logger.error("Something went wrong")
  # Generates: bpf_printk("[ERROR] Something went wrong");
  
  0
end
```

## Implementation Details

- Logger calls are translated to `bpf_printk` function calls
- Log level prefixes are automatically added to all messages
- String interpolation (`"text #{variable}"`) is converted to printf-style format strings
- All interpolated variables must be integers (eBPF limitation)
- Both `Logger.warn` and `Logger.warning` are supported for compatibility

## Examples

### Basic Usage
```elixir
Logger.info("Starting eBPF program")
# Output: [INFO] Starting eBPF program
```

### With Variables
```elixir
count = 42
Logger.debug("Processing #{count} packets")
# Output: [DEBUG] Processing 42 packets
```

### Error Handling
```elixir
error_code = -1
Logger.error("Failed with code #{error_code}")
# Output: [ERROR] Failed with code -1
```

### Compatibility
```elixir
# Both forms work (warning is preferred)
Logger.warn("Deprecated but supported")    # [WARN]
Logger.warning("Modern Elixir syntax")     # [WARN]
```

## Technical Notes

- String interpolation automatically converts variables to `%d` format specifiers
- Complex expressions in interpolation are supported: `"Value: #{x + y}"`
- The original Logger semantics are preserved while being optimized for eBPF
- All Logger calls return an integer (following eBPF conventions)