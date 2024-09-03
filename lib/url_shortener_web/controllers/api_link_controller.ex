defmodule UrlShortenerWeb.Api.LinkController do
  use UrlShortenerWeb, :controller

  alias UrlShortener.Links

  action_fallback UrlShortenerWeb.Api.FallbackController

  def create(%Plug.Conn{params: %{"url" => url}} = conn, _) do
    url = String.trim(url)

    with {:ok, link} <- Links.create_link(url) do
      render(conn, :link, link: link)
    end
  end

  @spec get(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def get(%{params: %{"shortLink" => short_link}} = conn, _) do
    link =
      short_link
      |> String.trim()
      |> Links.get_by_short_link()

    render(conn, :link, link: link)
  end
end
