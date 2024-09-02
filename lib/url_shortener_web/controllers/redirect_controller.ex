defmodule UrlShortenerWeb.RedirectController do
  use UrlShortenerWeb, :controller

  alias UrlShortener.Links.Link
  alias UrlShortener.Links

  def get(conn, %{"token" => token}) do
    case Links.maybe_get_by_token(token) do
      %Link{} = link ->
        Task.start(fn -> Links.increment_views(link) end)

        conn
        |> redirect(external: link.url)

      nil ->
        conn
        |> send_resp(404, "Not Found")
    end
  end
end
