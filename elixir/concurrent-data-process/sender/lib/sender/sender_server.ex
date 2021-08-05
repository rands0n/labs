defmodule SenderServer do
  @moduledoc false
  use GenServer, restart: :transient

  @impl true
  def init(args) do
    IO.puts("Received args #{inspect(args)}")
    max_retries = Keyword.get(args, :max_retries, 5)

    {:ok, %{emails: [], max_retries: max_retries}}
  end

  @spec start_link(any(), [
          {:debug, [:log | :statistics | :trace | {any(), any()}]}
          | {:hibernate_after, :infinity | non_neg_integer()}
          | {:name, atom() | {:global, any()} | {:via, atom(), any()}}
          | {:spawn_opt, [:link | :monitor | {any(), any()}]}
          | {:timeout, :infinity | non_neg_integer()}
        ]) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(args, opts \\ []) do
    GenServer.start_link(__MODULE__, args, opts)
  end

  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast({:send, email}, state) do
    _status = case Sender.send(email) do
      :ok ->
        "sent"
      :error ->
        "error"
    end

    {:noreply, %{state | emails: [email] ++ state.emails}}
  end

  @impl true
  def handle_info(:retry, state) do
    {failed, done} =
      Enum.split_with(state.emails, fn item ->
        item.status == "failed" && item.retries < state.max_retries
      end)
  end
end
