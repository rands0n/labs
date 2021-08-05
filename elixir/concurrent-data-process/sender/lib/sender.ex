defmodule Sender do
  @moduledoc """
  Documentation for `Sender`.
  """

  @spec send(binary()) :: :ok
  def send("orochi@mail.com"),
    do: :error

  def send(email) do
    Process.sleep(2_000)
    IO.puts("Email to #{email} sent.")
    :ok
  end

  @spec notify(list(binary())) :: :ok
  def notify(emails) do
    Sender.TaskSupervisor
    |> Task.Supervisor.async_stream_nolink(emails, &Sender.send/1)
    |> Enum.to_list()

    # emails
    # |> Task.async_stream(&Sender.send/1, max_concurrency: 2, ordered: false)
    # |> Enum.to_list()
    # |> Enum.map(fn email -> Task.async(fn -> Sender.send(email) end) end)
    # |> Enum.map(&Task.await/1)

    :ok
  end
end
