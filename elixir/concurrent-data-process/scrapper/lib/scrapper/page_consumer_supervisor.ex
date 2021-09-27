defmodule Scrapper.PageConsumerSupervisor do
  @moduledoc false
  use ConsumerSupervisor

  require Logger

  alias Scrapper.Consumers.Page, as: PageConsumer

  def start_link(args),
    do: ConsumerSupervisor.start_link(__MODULE__, args)

  def init(_args) do
    Logger.info("PageConsumerSupervisor init...")

    children = [
      %{
        id: PageConsumer,
        start: {PageConsumer, :start_link, []},
        restart: :transient
      }
    ]

    opts = [
      strategy: :one_for_one,
      subscribe_to: [
        {Scrapper.OnlineProducerConsumer.via("online_producer_consumer_1"), []},
        {Scrapper.OnlineProducerConsumer.via("online_producer_consumer_2"), []}
      ]
    ]

    ConsumerSupervisor.init(children, opts)
  end
end
