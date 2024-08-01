defmodule Utils do
  @moduledoc false

  @doc """
  Returns a timestamp in milliseconds
  """
  @spec now_ms() :: integer()
  def now_ms do
    DateTime.to_unix(DateTime.utc_now(), :millisecond)
  end
end
