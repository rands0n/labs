defmodule Counter.Core do
  @spec inc(non_neg_integer()) :: non_neg_integer()
  def inc(count), do: count + 1
end
