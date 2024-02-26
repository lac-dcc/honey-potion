# Lib/Honey Folder Documented

> This is where the code of Honey-Potion resides. In other words, this does the process of turning an elixir code into a C counterpart.

Our code is separated into many files inside the honey folder. Below are some of those files in order of usage.

## Guard 

Stops the execution of the program if some unwanted condition is met. For example if there is no main method in the user code.

## Info

Gathers information that would otherwise take too many lines of code or be complicated. Use to simplify code.

## Recursion_expansion

Defines the fuel macro and the functions to make it work.

_fuel: a macro that unrolls recursive calls into a fixed number of repeated calls, as eBPF doesn't allow recursive functions._

## Optimizer

> **DEPENDENCIES**: Uses files for static analysis and optimization of code. Currently: *variable analysis*, *dead_code_elimination*, *constant_propagation* and *type_propagation*.

Defines the optimization pipeline for Honey, as in, what modules are called in what order to optimize. Works on the AST of the source. Currently deactivated thanks to conflicts with pattern matching.

## Optimizer dependencies:

### variable_analysis

Analyzes the last use of variables, propagates that information upwards (liveness analysis) into the AST and verifies where a variable can be reutilized.

### constant_propagation

Does constant propagation and constant folding, evaluating constant expressions at compile time.

### dead_code_elimination

Cleans up the code by eliminating/refactoring dead code. For example, it checks variables that aren't being used and removes them or eliminates unnecessary constant expressions (e.g., if true then branch 1 else branch 2 **becomes** branch 1). 

### type_propagation

Annotates the Elixir-AST with type information into the metadata of relevant structures. We annotate the types of CTX variables and constants, then propagate those two throughout variables. As it stands, this is a mandatory step in compilation.

### Extra: ast_size and IO.inspect

In case users wish to see the AST or check it's size, they may uncomment the last two lines of code in `optimizer.ex`. These lines of code refer to the ast_size module and the inspect function of Elixir.

## Generator

Manages the calls to **Boilerplates** and to **Translator** to transform the user code into a Front-end and a Back-end code for eBPF. 

## Boilerplates

> **DEPENDENCIES**: Uses the functions and structures defined in /priv/c_boilerplates/runtime_functions.bpf.c and runtime_structures.bpf.h.

Adds and manages the boilerplate of C. Notably the #defines, structs, functions and other static parts that are always present in any target. 

## Translator

> **CHECK BEFORE**: Uses the functions and structures defined in /priv/c_boilerplates/runtime_functions.bpf.c and runtime_structures.bpf.h. Recommended read if you wish to understand better how the translation is done.

Translates the elixir code into C that uses methods defined in /priv/c_boilerplates/runtime_functions, such as basic math operators and structures defined in /priv/c_boilerplates/runtime_structures, such as a Generic datatype.

## Translated_code

Defines a struct for keeping C code.

## Write

Writes the output files and directories. Notably /src, /obj, /bin, a Makefile and the translated code into /src/code.c and code.bpf.c for the front-end and the back-end respectively.

## Compiler

> **DEPENDENCIES**: Uses /priv/c_boilerplates/runtime_functions.bpf.c and runtime_structures.bpf.h in the makefile as dependencies to define runtime functions and structures.

Compiles the files that were written in the last step using the Makefile. 

## Utils

Defines utilities for Honey, including but not limited to var_to_string, a function that transforms variables into strings, a function to map lines of original code to generated code and guards for AST segments.

## Directories

Creates the directories in the user directory to keep the source files, the compilation objects and the final binary. Also has methods to return some directories that are commonly used. 

