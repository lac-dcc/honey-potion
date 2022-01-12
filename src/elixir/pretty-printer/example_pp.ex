Code.require_file("pretty_printer.ex", ".")

defmodule AModule do
  def a_function(_a, _b, _c) do
    IO.puts("something")
  end
end

# It doesn't do anything useful, it just contains some different
# constructs, so we can see how the printer will behave
defmodule ExamplePP do
  def foo(a, b) do
    a + 3 + b
  end

  def bar(a, b) when a < 5 do
    a = a + 1
    AModule.a_function(a, b, 3)
    a + b
    !false

    case a do
      1 ->
        m = 2
        n = 1
        m + n

      2 ->
        false
    end

    case a do
      1 ->
        case b do
          2 ->
            m = 2
            n = 1
            m + n

          3 ->
            false
        end

      2 ->
        false
    end

    var = fn i, j ->
      k = i * j
      l = k - i
      l + 20
    end

    :foo
    a
  end

  def bar(a, b) do
    a = a + 2
    b = b + 2
    a + b
  end

  function_definition = Module.get_definition(__MODULE__, {:bar, 2})
  PrettyPrinter.complete_print(function_definition)
end
