defmodule Assertion do
  defmacro assert({operator, _, [lhs, rhs]}) do
    quote bind_quoted: [operator: operator, lhs: lhs, rhs: rhs] do
      Assertion.Test.assert(operator, lhs, rhs)
    end
  end

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)

      Module.register_attribute(__MODULE__, :tests, accumulate: true)

      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def run do
        Assertion.Test.run(@tests, __MODULE__)
      end
    end
  end

  defmacro test(desc, do: block) do
    test_func = String.to_atom(desc)

    quote do
      @tests {unquote(test_func), unquote(desc)}

      def unquote(test_func)(),
        do: unquote(block)
    end
  end
end


defmodule Assertion.Test do
  def run(tests, mod) do
    Enum.each(tests, fn {test_func, desc} ->
      case apply(mod, test_func, []) do
        :ok ->
          IO.write(".")
        {:fail, reason} ->
          IO.puts("""
          FAILURE: #{desc}
          #{reason}
          """)
      end
    end)
  end

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
    {:fail, """
    FAILURE:
      Expected:     #{lhs}
      Got:          #{rhs}
    """}
  end
end

defmodule MathTest do
  use Assertion

  test "integers can be added and subtracted" do
    assert 5 + 5 == 10
    assert 1 + 1 == 2
    assert 1 + 1 == 3
  end
end
