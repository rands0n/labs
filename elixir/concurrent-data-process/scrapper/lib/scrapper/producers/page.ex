defmodule Scrapper.Producers.Page do
  @moduledoc false
  use GenStage

  require Logger

  @spec start_link(any()) :: {:ok, pid()} | {:error, {:already_started, pid()}}
  def start_link(_args) do
    GenStage.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    Logger.info("PageProducer init...")
    {:producer, state}
  end

  @spec handle_demand(any(), any()) :: {:noreply, [], any()}
  def handle_demand(demand, state) do
    Logger.info("PageProducer received demand #{inspect(demand)} for pages")

    events = []

    {:noreply, events, state}
  end

  def scrape(pages) when is_list(pages),
    do: GenStage.cast(__MODULE__, {:pages, pages})

  def handle_cast({:pages, pages}, state) do
    {:noreply, pages, state}
  end
end
