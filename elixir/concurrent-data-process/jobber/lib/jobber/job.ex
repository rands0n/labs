defmodule Jobber.Job do
  @moduledoc """
  Defines a Job.
  """
  use GenServer, restart: :transient

  require Logger

  defmodule State do
    defstruct [
      :id,
      :work,
      :max_retries,
      status: "new",
      retries: 0
    ]

    @type t :: %__MODULE__{
      id: binary(),
      work: binary(),
      max_retries: non_neg_integer(),
      status: binary(),
      retries: non_neg_integer()
    }
  end

  @impl true
  def init(args) do
    Process.flag(:trap_exit, true)

    id = Keyword.get(args, :id)
    work = Keyword.fetch!(args, :work)
    max_retries = Keyword.get(args, :max_retries, 3)

    {:ok, %State{
      id: id,
      work: work,
      max_retries: max_retries
    }, {:continue, :run}}
  end

  def start_link(args) do
    args = if Keyword.get(args, :id) do
      args
    else
      Keyword.put(args, :id, random_job_id())
    end

    id = Keyword.get(args, :id)
    type = Keyword.get(args, :type)

    GenServer.start_link(__MODULE__, args, name: via(id, type))
  end

  @impl true
  def handle_continue(:run, %State{} = state) do
    new_state = state.work.()
    |> handle_job_result(state)

    if new_state.status == "error" do
      Process.send_after(self(), :retry, 5_000)
      {:noreply, new_state}
    else
      Logger.info("Job exiting #{state.id}")
      {:stop, :normal, new_state}
    end
  end

  @impl true
  def terminate(_reason, %State{} = state) do
    Logger.info("Terminating Jobber #{state.id}")

    :ok
  end

  @impl true
  def handle_info(:retry, %State{} = state) do
    {:noreply, state, {:continue, :run}}
  end

  defp handle_job_result({:ok, _data}, %State{} = state) do
    Logger.info("Job completed #{state.id}")
    %State{state | status: "done"}
  end

  defp handle_job_result(:error, %State{status: "new"} = state) do
    Logger.warn("Job errored #{state.id}")
    %State{state | status: "error"}
  end

  defp handle_job_result(:error, %State{status: "error"} = state) do
    Logger.warn("Job errored #{state.id}")

    new_state = %State{state | retries: state.retries + 1}

    if new_state.retries == state.max_retries do
      %{new_state | status: "failed"}
    else
      new_state
    end
  end

  defp random_job_id do
    :crypto.strong_rand_bytes(5)
    |> Base.url_encode64(padding: false)
  end

  defp via(key, value) do
    {:via, Registry, {Jobber.JobRegistry, key, value}}
  end
end
