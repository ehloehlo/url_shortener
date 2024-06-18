defmodule UrlShortenerWeb.Live.UrlController do
  use UrlShortenerWeb, :live_view

  def render(assigns) do
    ~H"""
      Hello!
    """
  end
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event(_event_name, _params, socket) do
    {:noreply, socket}
  end
end
