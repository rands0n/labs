defmodule Scrapper do
  @moduledoc """
  Documentation for `Scrapper`.
  """

  @spec work :: :ok
  def work do
    1..5
    |> Enum.random()
    |> :timer.seconds()
    |> Process.sleep()
  end

  @spec online?(binary()) :: boolean()
  def online?(_url) do
    work()

    Enum.random([false, true, true])
  end
end
