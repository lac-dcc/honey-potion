# 🍯 Honey Potion - Writing eBPF with Elixir 🍯

[![Hex Version](https://img.shields.io/hexpm/v/honey.svg)](https://hex.pm/packages/honey)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/honey/)
[![Total Download](https://img.shields.io/hexpm/dt/honey.svg)](https://hex.pm/packages/honey)
[![License](https://img.shields.io/hexpm/l/honey.svg)](https://github.com/lac-dcc/honey-potion/blob/master/LICENSE)
[![Last Updated](https://img.shields.io/github/last-commit/lac-dcc/honey-potion.svg)](https://github.com/lac-dcc/honey-potion/commits/master)

<p align="center">
  </br>
  <img alt="logo" src="./assets/honey.png" width="25%" height="auto"/>
</p>

## Description
*Honey Potion* is a framework that brings the powerful eBPF technology into Elixir. Users can write Elixir code that will be transformed into eBPF bytecodes. Many high-level features of Elixir are available and more will be added soon.
In this alpha version, the framework translates the code to a subset of C that uses [libbpf](https://github.com/libbpf/libbpf)'s features. Then it's possible to use `clang` to obtain the bytecodes and load it into the Kernel.

## Installation

The package can be installed by adding `honey` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:honey, git: "https://github.com/lac-dcc/honey-potion/"}
  ]
end
```

## Usage
When you `use Honey` in your module, it'll be translated to C the next time you compile the project. For example:
```elixir
defmodule Minimal do
  use Honey, license: "Dual BSD/GPL"

  # ...
end
```

Will generate `Minimal.bpf.c` in the same folder as the module.

Notice the `license` option: as eBPF demands, we need to specify a license to our program.
Currently, `Honey` accepts one more option besides the license. The option `clang_formater` can take the path of the `clang-formater` executable, and it'll use it to beautify the C file generated.

#### Main function
A module that uses `Honey` must define a function `main/1` that receives a `ctx`. The main function is the entry point of our eBPF program. For example:
```elixir
defmodule Example.Minimal do
  use Honey, license: "Dual BSD/GPL"

  @sec "tracepoint/syscalls/sys_enter_kill"
  def main(ctx) do
    # ...
  end
end
```
Notice the `@sec` decorator: The main function must specify its program type, according to the available options in `libbpf`. The argument received, `ctx`, is a struct whose fields vary depending on the program type.
In its Alpha version, only one type is allowed: `tracepoint/syscalls/sys_enter_kill`.

The main function must return an integer, otherwise an exception will be thrown at runtime (see Runtime Exceptions below).

#### Maps
Users can define maps using the macro `defmap`. For example, to create a map named `my_map`, you can:

```elixir
defmap(:my_map,
     %{type: BPF_MAP_TYPE_ARRAY,
     max_entries: 10}
)
```

In the Alpha version, just the map type `BPF_MAP_TYPE_ARRAY` is available, but you only need to specify the number of entries and the map is ready to use.


#### Helper functions
eBPF and `libbpf` provides some helper functions, and so does *Honey*. In the Alpha version, there is a single module you can import:

`import Honey.Bpf.Bpf_helpers`

Referencing the usual `#include <bpf/bpf_helpers>`, this module allows you to call:
 - **bpf_map_lookup_elem(map, key)** ➜ Map access are easy, you can pass the name of the map declared with `defmap` and the key (currently, only integer), and the function will the return the value to you. In the Alpha version, if it is not possible to access that position of the map, a Runtime exception will be thrown.

  - **bpf_map_update_elem(map, key, value)** ➜ Update a position in a map. It receives the name of the map, the key (currently, only integers) and the value to be updated. The return is 0 on success, or a negative error in case of failure.

  - **bpf_printk(params)** ➜ Send a string to the debug pipe. In this Alpha version, `params` is an array. The first position must be a string containing up to three format specifiers `%d`. The number of next elements must be the same number of `%d` used. For example:

    ```elixir
    bpf_printk(["I am printing the number %d, and also %d.", n1, n2])
    ```

    You can read the pipe with `sudo cat /sys/kernel/debug/tracing/trace_pipe`. In the Alpha version, only variables of type integers can be printed.

  - **bpf_get_current_pid_tgid()** ➜ Return the PID of the process that triggered the eBPF program.

#### Recursive functions
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

## Runtime Exceptions
Exceptions are a natural part of dynamically-typed languages such as Elixir. To allow many of the high-level constructs of Elixir, we simulate the notion of Runtime Exceptions when translating programs to eBPF.
In this Alpha version, when a Runtime Exception is thrown, the program will print the exception message to the debug pipe, and return with `0`.

## Current limitations
This framework is still Alpha, and we have lots of features to add, improve and correct. Amongst the current known limitations are:
- We cannot destructure elements while doing pattern matching. Because of that, the matching operator `=` is working like a traditional assignment operator with only a simple variable in the left-hand side. For the same reason, `case` and `if-else` blocks are not supported, unless they are totally optimized out at compile time.
- Only a small number of operators are available, such as `+`, `-`, `*`, `/` and `==`.
- We do not support function guards nor default arguments.
- We do not support mutual recursive functions.
- We do not support user-defined structs.

There are more, and we are actively working to improve it.

## Contributing
Contributions are very welcome! If you are interested in collaborating, let's stay in touch so our work doesn't overlap.
Feedback and suggestions are also very much appreciated! You can file a [GitHub issue](https://github.com/lac-dcc/honey-potion/issues) or contact us at `vinicpac@gmail.com`.

## Copyright & License
Copyright (C) 2022 Compilers Laboratory - Federal University of Minas Gerais (UFMG), Brazil

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
