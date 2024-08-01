defmodule UrlShortener.RateLimit do
  @moduledoc """
  ETS-based storage to count user's requests
  """

  use GenServer

  require Logger

  @table_name :rate_limit

  # TODO: make dynamically configurable
  @max_req_per_min 10
  @cleanup_interval :timer.seconds(60)

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    table =
      :ets.new(
        @table_name,
        [
          :named_table,
          :set,
          :public,
          read_concurrency: true,
          write_concurrency: true
        ]
      )

    schedule_cleanup()

    {:ok, %{table: table}}
  end

  def log_user_req(user_id) do
    case :ets.update_counter(
           @table_name,
           user_id,
           # increment by 1
           {2, 1},
           # or insert with timestamp
           {2, 0, Utils.now_ms()}
         ) do
      cnt when cnt > @max_req_per_min -> {:error, :rate_limited}
      _cnt -> :ok
    end
  rescue
    error ->
      {:error, error}
  end

  def prune do
    GenServer.call(__MODULE__, :prune)
  end

  def handle_info({:cleanup, schedule_next}, state) do
    Logger.debug("Cleaning up expired requests...")

    if schedule_next do
      schedule_cleanup()
    end

    threshold = Utils.now_ms() - @cleanup_interval
    :ets.select_delete(@table_name, [{{:_, :_, :"$1"}, [{:<, :"$1", threshold}], [true]}])

    {:noreply, state}
  end

  def handle_call(:prune, _from, state) do
    Logger.debug("Pruning database...")

    :ets.delete_all_objects(@table_name)
    {:reply, :ok, state}
  end

  defp schedule_cleanup do
    Process.send_after(self(), {:cleanup, true}, @cleanup_interval)
  end
end
