# Lib/Honey Folder Documented

> This is where the code of Honey-Potion resides. In other words, this does the process of turning an elixir code into a C counterpart.

All files have a specific function detailed below.

Important dependencies are mentioned, except for Utils (used in MANY files).

## Boilerplates

> **DEPENDENCIES**: Uses the /priv/c_boilerplates/runtime_functions.c to define runtime functions.

Adds and manages the boilerplate of C. Notably the #defines, structs, functions and other static parts that are always present in any target. 

## Optimizer
> **DEPENDENCIES**: Uses files for static analisis and optimization of code. Currently: *dead_code_elimination* and *constant_propagation*

Defines the optimization pipeline for Honey, as in, what modules are called in what order to optimize. Works on the AST of the source.

## Optimizer dependencies:

### constant_propagation

Does constant propagation and constant folding, evaluating constant expressions at compile time.

### dead_code_elimination

Cleans up the code by eliminating/refactoring dead code. For example, it checks variables that aren't being used and removes them or eliminates unecessary constant expressions (e.g., if true then branch 1 else branch 2 **becomes** branch 1). 

## Recursion_expansion

Defines the fuel macro and the functions to make it work.

_fuel: a macro that unrolls recursive calls into a fixed number of repeated calls, as eBPF doesn't allow recursive functions._

## Translated_code

Defines a struct for keeping C code.

## Translator

> **CHECK BEFORE**: Uses the /priv/c_boilerplates/runtime_functions.c for certain methods, for full understanding of it we recommend you familiarize yourself with it before reading the translator.

Translates the elixir code into C that uses methods defined in Priv/C_boilerplates/runtime_functions, such as basic math operators.

## Utils

Defines utilities for Honey, including but not limited to var_to_string and a function to map lines of original code to generated code.
