defmodule Math do
  defmacro say({:+, _, [lhs, rhs]}) do
    quote do
      lhs = unquote(lhs)
      rhs = unquote(rhs)
      result = lhs + rhs
      IO.puts("The result of #{lhs} + #{rhs} is: #{result}")
      result
    end
  end

  defmacro say({:*, _, [lhs, rhs]}) do
    quote do
      lhs = unquote(lhs)
      rhs = unquote(rhs)
      result = lhs * rhs
      IO.puts("The result of #{lhs} * #{rhs} is: #{result}")
      result
    end
  end
end

# require Math

# Math.say(5 + 2)
# Math.say(5 * 2)
