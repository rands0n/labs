defmodule ControlFlow do
  defmacro unless(expr, do: blck) do
    quote do
      if !unquote(expr),
        do: unquote(blck)
    end
  end
end

# require ControlFlow

# ControlFlow.unless(2 == 5),
#   do: "block entered"

# ControlFlow.unless(2 == 5) do
#   "block entered"
# end
