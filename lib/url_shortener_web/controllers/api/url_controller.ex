defmodule UrlShortenerWeb.Api.UrlController do
  use UrlShortenerWeb, :controller

  alias UrlShortener.Shortener
  alias UrlShortenerWeb.ErrorJSON

  def create(%Plug.Conn{params: %{"link" => link}} = conn, _) do
    link
    |> String.trim()
    |> Shortener.create_url()
    |> case do
      {:ok, url} ->
        render(conn, :url, %{url: url})

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(422)
        |> put_view(ErrorJSON)
        |> render(:"422", changeset: changeset)
    end
  end

  def get(%{params: %{"shortLink" => link}} = conn, _) do
    url =
      link
      |> String.trim()
      |> Shortener.get_by_short_link()

    render(conn, :url, %{url: url})
  end
end
