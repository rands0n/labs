defmodule Scrapper.Application do
  @moduledoc false

  use Application

  alias Scrapper.Producers.Page, as: PageProducer

  @impl true
  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: Scrapper.ProducerConsumerRegistry},
      PageProducer,
      producer_consumer_spec(id: 1),
      producer_consumer_spec(id: 2),
      Scrapper.OnlineProducerConsumer,
      Scrapper.PageConsumerSupervisor
    ]

    Supervisor.start_link(
      children,
      [strategy: :one_for_one, name: Scrapper.Supervisor]
    )
  end

  defp producer_consumer_spec(id: id) do
    id = "online_producer_consumer_#{id}"

    Supervisor.child_spec({Scrapper.OnlineProducerConsumer, id}, id: id)
  end
end
