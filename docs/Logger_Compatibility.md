# Logger Compatibility Notes

## `Logger.warn` vs `Logger.warning`

In Elixir 1.15+, `Logger.warn` has been deprecated in favor of `Logger.warning`. Honey Potion supports both functions for compatibility:

### Supported Functions

- ✅ `Logger.warning/1` and `Logger.warning/2` (preferred)
- ✅ `Logger.warn/1` and `Logger.warn/2` (deprecated but supported)

### Output

Both functions produce identical output with the `[WARN]` prefix:

```elixir
Logger.warn("Old syntax")       # Outputs: "[WARN] Old syntax" 
Logger.warning("New syntax")    # Outputs: "[WARN] New syntax"
```

### Migration Recommendation

For new code, prefer `Logger.warning`:

```elixir
# Old (deprecated)
Logger.warn("Something went wrong")

# New (preferred)
Logger.warning("Something went wrong")
```

### Compatibility Matrix

| Elixir Version | `Logger.warn` | `Logger.warning` | Honey Potion Support |
|----------------|---------------|------------------|---------------------|
| < 1.11         | ✅ Available  | ❌ Not available | ✅ `warn` only      |
| 1.11 - 1.14    | ✅ Available  | ✅ Available     | ✅ Both supported   |
| 1.15+          | ⚠️ Deprecated | ✅ Available     | ✅ Both supported   |

This ensures your eBPF code works across different Elixir versions while encouraging modern practices.