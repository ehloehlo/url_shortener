defmodule UrlShortenerWeb.UrlController do
  use UrlShortenerWeb, :controller

  alias UrlShortener.Links.Url
  alias UrlShortener.Shortener

  def get(conn, %{"token" => token}) do
    case Shortener.maybe_get_by_token(token) do
      %Url{} = url ->
        Task.start(fn -> Shortener.increment_views(url) end)

        conn
        |> redirect(external: url.link)

      nil ->
        conn
        |> send_resp(404, "Not Found")
    end
  end
end
