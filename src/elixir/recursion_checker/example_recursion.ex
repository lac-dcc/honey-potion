Code.require_file("recursion_checker.ex", ".")

defmodule Example do

  def f1() do
    f2()
    f3()
    f6()
  end

  def f2() do
    f3()
  end

  def f3() do
    f4()
  end

  def f4() do
    f2()
  end

  def f5() do
    f1()
  end

  def f6() do
  end

  if RecursionChecker.is_recursive?(__MODULE__) do
    IO.puts("\n~> This program contains recursive calls. <~\n")
  else
    IO.puts("\n~> This program DOES NOT contain recursive calls. <~\n")
  end
end
