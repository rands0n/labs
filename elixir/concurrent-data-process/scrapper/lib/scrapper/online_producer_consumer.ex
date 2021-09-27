defmodule Scrapper.OnlineProducerConsumer do
  @moduledoc false
  use GenStage

  require Logger

  alias Scrapper.Producers.Page, as: PageProducer

  @spec start_link(any()) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(id),
    do: GenStage.start_link(__MODULE__, [], name: via(id))

  def via(id),
    do: {:via, Registry, {Scrapper.ProducerConsumerRegistry, id}}

  def init(state) do
    Logger.info("OnlineProducerConsumer init...")

    subs = [
      {PageProducer, min_demand: 0, max_demand: 1}
    ]

    {:producer_consumer, state, subscribe_to: subs}
  end

  def handle_events(events, _from, state) do
    Logger.info("OnlineProducerConsumer received #{inspect(events)}")

    events = Enum.filter(events, &Scrapper.online?/1)

    {:noreply, events, state}
  end
end
