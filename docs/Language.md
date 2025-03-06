# Honey-Lang
Honey gives to the user a specific subset of the elixir language that is translated to C. To study this language and learn how it works you can check any of our examples at the `examples/lib` folder. However, if you'd like to read the documentation of it's parts instead of reading examples, this is the right place.

## Boilerplates
To create valid BPF code, Honey-Potion will add a big amount of boilerplate to the C code generated. This boilerplate isn't important to the user and can be ignored.

## Variables & Constants
Variables and constants can be represented by a constant value in C or it can become a Dynamic variable. Dynamic is the name of the type that we created in C that allows us to represent many different types within only one variable. This was done to allow situations where a single expression can return more than one type, which can't be naturally represented in C.

Variables in Elixir are immutable. For that to be possible, each variable is kept with a metadata that shows the "version" of the variable. So if a variable X is declared twice, both exist, but they will have different versions. As C doesn't support that, we represent it as a variable whose name is structured like \<name\_version\_context\>. For example, we could have `X_1_` and `X_2_` in the translated version.

## Case, Cond and If expressions
All of these expressions will be translated as a series of if's for each of the cases/conditions. The one that turns out to be true will keep the result in a "Helper variable" used to keep a temporary value for a short time. That value is then transferred to the variable that the user has created.

## eBPF Maps
Maps in eBPF can be created using the `defmap` macro. A typical map can be represented like this:

```
defmap{
:NameOfMap,
%{type: TypeOfMap, max_entries: MaxMapEntries, @print = true, @print_elem = [{"name1", key1}, {"name2", key2}, ...]}
}
```

Where attributes with a @ are optional and can be disabled. The map is represented with a 2 element tuple. 
- First atom: The name of the map, used for map operations and printing display
- Elixir Map: Keeps the other attributes of the map
  - type: represents the type of map created. Currently Honey supports both `BPF_MAP_TYPE_ARRAY` and `BPF_MAP_TYPE_HASH`.
  - max\_entries: defines the number of entries that are allowed into the map.
  - print: set to true if the map should be printed in the user's terminal
  - print\_elem: defines what elements should be printed with what names.

#### Functions used for maps.
Maps support functions to read and write data into it. The two main functions given to the user (that are also BPF-Helper functions) are:

`Honey.BpfHelpers.bpf_map_lookup_elem` and `Honey.BpfHelpers.bpf_map_update_elem`. The first one looks for a key in a map and the second one updates a key with a new value within a map.

Both of them take in the map name as an atom and the key as the first two arguments and `bpf_map_update_elem` takes the new value as the third argument.

## BPF-Helper Functions
Honey gives the user direct access to some of the functions in the BPF-Helper library. The most notable one is `Honey.BpfHelpers.bpf_printk`, which allows you to print a C-formatted string to `/sys/kernel/debug/tracing/trace_pipe`. To read the output, just cat that directory and it will update live. The other two have been described in the above section.

## Recursive Functions
It is possible to define recursive functions and call them from `main/1`. For example, let's define a function that recursively sums two natural numbers:
```elixir
def sum(a, b) do
  if b == 0 do
     a
  else
    sum(a + 1, b - 1)
  end
end
```

To avoid infinite recursion and satisfy the eBPF verifier, we require you to inform a constant number that will be used to limit the maximum depth of recursion at runtime. This is done through the macro `fuel`. Its syntax is:
`fuel max_number, function_call(...)`

Let's see an example inside main:
```elixir
@sec "tracepoint/syscalls/sys_enter_kill"
def main(ctx) do
  x = 100
  y = fuel 10, sum(x, 5)
  bpf_printk(["The value of y is %d", y])
end
```
We provide a constant amount of `10` units fuel in the first call `sum`. Each time `sum` calls itself, it burns one unit of fuel. If, at some point, `sum` tries to calls itself again with no fuel remaining, a Runtime Exception will be thrown and the program will halt.

