defmodule Cond do
  use Honey, license: "Dual BSD/GPL"

  #Here to show that cond(s) are broken in last version.

  #Removing one of the two >to_bool< functions in the if clauses of the translation leads to a compiling code.
  #Changing >to_bool< to return 0 or 1 also compiles.
  #Removing all mentions of string_pool in >to_bool< seems to be what makes it work or fail.
  #Other compiled examples don't have >to_bool<.
  #Consider removing to_bool from translations
  #Other examples with comparissons check the .start instead of checking character by character of string_pool to identify if the atom is true, false or nil.
  #The problem also seems to arise when there are too many conditions, reducing the number of conditions worked to fix it.
  #Increasing/decreasing the possible conds here don't seem to make a difference.
  #I left the solution as an extremely simplified to_bool.


  @sec "tracepoint/raw_syscalls/sys_enter"
  def main(_) do
   x = 32
   cond do
     x == 23 -> Honey.Bpf_helpers.bpf_printk(["Is 23."])
     x == 23445 -> Honey.Bpf_helpers.bpf_printk(["Is 23445."])
     x == 51234 -> Honey.Bpf_helpers.bpf_printk(["Is 51234."])
     x== 32 -> Honey.Bpf_helpers.bpf_printk(["Is 32."])
   end
  end
end
