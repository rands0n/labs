defmodule Airports do
  @moduledoc """
  Documentation for `Airports`.
  """

  alias NimbleCSV.RFC4180, as: CSV

  @spec all :: list()
  def all do
    Application.app_dir(:airports, "/priv/airports.csv")
    |> File.stream!()
    |> Stream.map(fn ev ->
      Process.sleep(Enum.random([0, 0, 0, 1]))
      ev
    end)
    |> Flow.from_enumerable()
    |> Flow.map(fn row ->
      [row] = CSV.parse_string(row, skip_headers: false)

      %{
        id: Enum.at(row, 0),
        type: Enum.at(row, 2),
        name: Enum.at(row, 3),
        country: Enum.at(row, 8)
      }
    end)
    |> Flow.reject(&(&1.type == "closed"))
    |> Flow.partition(
      stages: 1,
      window: Flow.Window.trigger_every(Flow.Window.global(), 1_000),
      key: {:key, :country}
    )
    |> Flow.group_by(&(&1.country))
    |> Flow.on_trigger(fn acc, _partition_info, {_type, _id, trigger} ->
      events =
        acc
        |> Enum.map(fn {country, data} -> {country, Enum.count(data)} end)
        |> IO.inspect(label: inspect(self()))

      case trigger do
        :done ->
          {events, acc}
        {:every, 1_000} ->
          {[], acc}
      end
    end)
    |> Enum.sort(fn {_, a}, {_, b} -> a > b end)
    |> Enum.take(10)
  end
end
