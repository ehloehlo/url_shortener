defmodule UrlShortenerWeb.Web.UrlController do
  use UrlShortenerWeb, :controller

  alias UrlShortener.Links.Url
  alias UrlShortener.Shortener

  def get(conn, %{"token" => token}) do
    case Shortener.get_by_token(token) do
      %Url{} = url ->
        Task.start(fn -> Shortener.increment_views(url) end)

        conn
        |> redirect(external: url.link)

      nil ->
        conn
        |> put_status(404)
        |> render(:"404")
    end
  end
end
