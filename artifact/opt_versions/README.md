# Enabling/Disabling Optimizations

Honey Potion currently implements three optimizations:

* *Constant Propagation*: solves computations involving constants at code-generation time, and propagates these constants.
* *Dead-Code Elimination*: removes unreachable code from the program's control-flow graph.
* *Type Propagation*: propagates type annotations (available as eBPF arguments) throughout the program code.

Currently, it is not possible to enable or disable these optimizations via command line: they are hard-coded in the compiler, in the [optimizer.ex](../../lib/honey/optimizer.ex) module, e.g.:

```elixir
defmodule Honey.Optimization.Optimizer do
  alias Honey.{ConstantPropagation, DeadCodeElimination, TypePropagation}
  alias Honey.Analysis.SemanticAnalysis

  def run(fun_def, arguments, env) do
    fun_def 
    |> SemanticAnalysis.run()
    |> ConstantPropagation.run()
    |> DeadCodeElimination.run()
    |> TypePropagation.run(arguments, env)
  end
end
```

However, to test Honey Potion without some of the optimizations, you can simply comment those that you want out.
This folder contains different implementations of the optimizer, with some of the optimizations disabled.
As an example, [this](constProp_TypeProp) file disables dead-code elimination and prints out the size of the abstract syntax tree of Honey Potion's intermediate program representation:

```elixir
defmodule Honey.Optimization.Optimizer do
  alias Honey.{ConstantPropagation, DeadCodeElimination, TypePropagation}
  alias Honey.Analysis.SemanticAnalysis

  def run(fun_def, arguments, env) do
    fun_def 
    |> SemanticAnalysis.run()
    |> ConstantPropagation.run()
    # |> DeadCodeElimination.run()
    |> TypePropagation.run(arguments, env)
    |> Honey.Analysis.AstSize.output(env, " - Final")
  end
end
```

You can check the effect of disabling these optimizations by evaluating our Research Question 5, via [this](../rq4.sh) script.
The script copies into the Honey Potion library different versions of the optimizer module, and then restores the library after collecting measurements.