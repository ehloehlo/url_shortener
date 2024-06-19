defmodule UrlShortenerWeb.Web.UrlLiveController do
  use UrlShortenerWeb, :live_view

  alias UrlShortener.Shortener

  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign(url: %{"link" => nil}, errors: [])
    }
  end

  def handle_event("shorten_link", %{"link" => link}, socket) do
    socket =
      link
      |> String.trim()
      |> Shortener.create_url()
      |> case do
        {:ok, url} ->
          assign(
            socket,
            url: %{"link" => link, "short_link" => Shortener.build_link(url.token)},
            errors: []
          )

        {:error, %Ecto.Changeset{} = changeset} ->
          assign(socket,
            url: %{"link" => link, "short_link" => nil},
            errors: translate_errors(changeset.errors, :link)
          )
      end

    {:noreply, socket}
  end

  def handle_event(_event, _unsigned_params, socket) do
    {:noreply, socket}
  end
end
