defmodule Scrapper.Consumers.Page do
  @moduledoc false
  require Logger

  @spec start_link(any()) :: {:ok, pid()}
  def start_link(event) do
    Logger.info("PageConsumer received event #{inspect(event)}...")

    Task.start_link(fn ->
      Scrapper.work()
    end)
  end
end
