defmodule UrlShortenerWeb.LinkLive.Index do
  use UrlShortenerWeb, :live_view

  alias UrlShortener.Links
  alias UrlShortener.Links.Link

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      assign(socket, link: %{"url" => nil}, errors: [])
    }
  end

  @impl true
  def handle_event("save", %{"url" => url}, socket) do
    case String.trim(url) |> Links.create_link() do
      {:ok, %Link{token: token}} ->
        short_link = Links.build_link(token)

        {
          :noreply,
          socket
          |> assign(link: %{"url" => url}, errors: [])
          |> put_flash(:info, [
            "Link created: ",
            raw("<a href=\"#{short_link}\">#{short_link}</a>")
          ])
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         assign(socket,
           link: %{"url" => url},
           errors: translate_errors(changeset.errors, :url)
         )}
    end
  end
end
