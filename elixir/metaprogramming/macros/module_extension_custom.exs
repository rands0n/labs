defmodule Assertion do
  defmacro assert({operator, _, [lhs, rhs]}) do
    quote bind_quoted: [operator: operator, lhs: lhs, rhs: rhs] do
      Assertion.Test.assert(operator, lhs, rhs)
    end
  end

  defmacro extend(opts \\ []) do
    quote do
      import unquote(__MODULE__)

      def run do
        IO.puts("Running tests...")
      end
    end
  end
end

defmodule MathTest do
  require Assertion
  Assertion.extend()
end
