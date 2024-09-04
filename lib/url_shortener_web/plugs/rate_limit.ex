defmodule UrlShortenerWeb.Plugs.RateLimit do
  @moduledoc """
  Plug to limit request rate
  """

  require Logger

  defmodule TooManyRequestsError do
    defexception message: "too many requests", plug_status: 429
  end

  def init(opts), do: opts

  def call(%Plug.Conn{assigns: %{user_id: user_id}} = conn, _opts) do
    case UrlShortener.RateLimit.log_user_req(user_id) do
      {:error, :rate_limited} ->
        raise TooManyRequestsError

      {:error, error} ->
        Logger.warning(error)
        conn

      _ ->
        conn
    end
  end

  def call(conn, _opts), do: conn
end
