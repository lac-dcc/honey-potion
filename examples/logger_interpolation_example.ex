defmodule LoggerInterpolationExample do
  @moduledoc """
  Example showing Logger with string interpolation support.
  This demonstrates how the new interpolation feature works in practice.
  """

  def main() do
    pid = 1234
    user_id = 9876
    
    # Simple interpolation
    Logger.info("Process PID: #{pid}")
    
    # Multiple interpolations
    Logger.debug("User #{user_id} started process #{pid}")
    
    # Mixed with other log levels
    Logger.error("Critical error in PID #{pid}")
    
    # Regular string (should still work)
    Logger.warning("This is a regular warning")
    
    0
  end
end