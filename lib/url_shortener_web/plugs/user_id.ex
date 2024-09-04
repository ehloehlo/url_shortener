defmodule UrlShortenerWeb.Plugs.UserId do
  @moduledoc """
  Creates an ID based on a user's IP address
  """

  import Plug.Conn

  def init(opts), do: opts

  def call(%Plug.Conn{assigns: %{user_id: _}} = conn, _opts), do: conn

  def call(%Plug.Conn{remote_ip: remote_ip} = conn, _opts) do
    assign(conn, :user_id, hash_user_ip(remote_ip))
  end

  @spec hash_user_ip(:inet.ip_address() | nil) :: String.t()
  defp hash_user_ip(ip) do
    ip = format_user_ip(ip)

    :crypto.hash(:blake2b, ip)
    |> Base.encode64(padding: false)
  end

  defp format_user_ip(nil = _ip), do: ""
  defp format_user_ip(ip_address) when is_tuple(ip_address), do: :inet.ntoa(ip_address)
end
