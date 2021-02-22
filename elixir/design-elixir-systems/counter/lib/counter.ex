defmodule Counter do
  @moduledoc """
  Response
  """

  @spec start(non_neg_integer()) :: {:ok, pid}
  @doc """
  Starts a new process of Counter.
  """
  def start(initial_count \\ 0) do
    {:ok, spawn(fn ->
      Counter.Server.run(initial_count)
    end)}
  end

  @spec tick(pid()) :: no_return()
  def tick(pid) do
    send(pid, {:tick, self()})
  end

  @spec state(pid()) :: non_neg_integer() | no_return()
  def state(pid) do
    send(pid, {:state, self()})

    receive do
      {:count, value} ->
        value
    end
  end
end
