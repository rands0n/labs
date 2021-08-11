defmodule Assertion do
  defmacro assert({operator, _, [lhs, rhs]}) do
    quote bind_quoted: [operator: operator, lhs: lhs, rhs: rhs] do
      Assertion.Test.assert(operator, lhs, rhs)
    end
  end
end

defmodule Assertion.Test do
  def assert(:==, lhs, rhs) when lhs == rhs,
    do: IO.write(".")

  def assert(:==, lhs, rhs),
    do: get_standard_assert(lhs, rhs)

  def assert(:>, lhs, rhs) when lhs > rhs,
    do: IO.write(".")

  def assert(:>, lhs, rhs),
    do: get_standard_assert(lhs, rhs)

  def assert(:>=, lhs, rhs) when lhs >= rhs,
    do: IO.write(".")

  def assert(:>=, lhs, rhs),
    do: get_standard_assert(lhs, rhs)

  def assert(:<, lhs, rhs) when lhs < rhs,
    do: IO.write(".")

  def assert(:<, lhs, rhs),
    do: get_standard_assert(lhs, rhs)

  def assert(:<=, lhs, rhs) when lhs <= rhs,
    do: IO.write(".")

  def assert(:<=, lhs, rhs),
    do: get_standard_assert(lhs, rhs)

  defp get_standard_assert(lhs, rhs) do
    IO.puts("""
    FAILURE:
      Expected:     #{lhs}
      Got:          #{rhs}
    """)
  end
end
