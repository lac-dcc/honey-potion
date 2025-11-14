defmodule Examples.LoggerExample do
  @moduledoc """
  Example demonstrating Logger usage in Honey Potion eBPF programs.
  
  This example shows how to use Elixir's Logger instead of raw bpf_printk calls.
  The Logger calls are automatically translated to bpf_printk with appropriate 
  log level prefixes.
  """

  def main(ctx) do
    Logger.info("Starting packet processing")
    
    # Get current process PID
    pid = Honey.BpfHelpers.bpf_get_current_pid_tgid()
    Logger.debug("Processing packet for PID: %d", pid)
    
    # Decision logic with different log levels
    cond do
      pid < 100 ->
        Logger.warn("Suspicious low PID detected: %d", pid)
        Logger.error("Dropping packet due to security policy")
        Honey.XDP.drop()
      
      pid > 50000 ->
        Logger.warn("Very high PID detected: %d", pid)
        Logger.info("Allowing packet but flagging for review")
        Honey.XDP.pass()
      
      true ->
        Logger.debug("Normal PID range, allowing packet")
        Logger.info("Packet processed successfully")
        Honey.XDP.pass()
    end
  end
end