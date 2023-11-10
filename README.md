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

## Dependencies
*Honey Potion* depends on a few BPF-related packages to run. Below are listed the packages with the ubuntu names. Other distros should have similar or equal names.

- erlang and elixir - For the language used in Honey Potion
- libbpf - Version 1.1 (See [YouTube video](https://www.youtube.com/watch?v=PhHs9u9toTg&list=PL9cmSHf85lF5HzCha020qegkKQ3GpiEBY&index=2) on how to get it)
- gcc-multilib - For C libraries (asm/types.h)
- make - For Makefile compilation
- llvm - For llc
- clang - For clang
- bpftool - For skeleton generation

Note that clang, llc and bpftool can be compiled by the user, as long as they are in the $PATH.

## YouTube
If you prefer the video format, Honey Potion has a [YouTube playlist](https://www.youtube.com/playlist?list=PL9cmSHf85lF5HzCha020qegkKQ3GpiEBY) with guides on how to set up Honey Potion and how to create example programs.

<p align="center">
  </br>
  <a href="https://www.youtube.com/playlist?list=PL9cmSHf85lF5HzCha020qegkKQ3GpiEBY"><img alt="YouTubeThumb" src="./assets/youtube.png" width="75%" height="auto"/>
</p>


## Installation

The package can be installed by adding `honey` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:honey, git: "https://github.com/lac-dcc/honey-potion/", submodules: true}
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

Will generate a few new sub-directories for you:

- src : Where the C code is kept, `Minimal.bpf.c` for example
- obj : Where compilation objects is be kept, `Minimal.o` for example
- bin : Where the executable is kept, `Minimal` for example

To run your program, just go into the bin directory and run the executable with privileges.

You may run the program with the `-p` flag to print all maps and the `-t <seconds>` flag to set how many seconds the program will run.

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

The main function must return an integer, otherwise an exception will be thrown at runtime (see Runtime Exceptions below).

If you wish to learn how to use Honey-Potion with a video, including the language and other details, [click here.](https://www.youtube.com/watch?v=Wis5e3vLcMg) Otherwise, check out the `docs/Language.md` file or the code examples in `/examples/lib` with special attention to `HelloWorld.ex`, `Maps.ex`, `CountSysCalls.ex` and `Forcekill.ex`.

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
-  To run the executable currently, executable has to be in bin folder and object in obj folder.

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
