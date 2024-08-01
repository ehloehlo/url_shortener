defmodule UrlShortenerWeb.Api.UrlJSON do
  alias UrlShortener.Links.Url
  alias UrlShortener.Shortener

  def url(%{url: url}), do: %{url: data(url)}

  defp data(%Url{} = url) do
    %{
      link: url.link,
      views: url.views,
      shortLink: render_short_link(url.token)
    }
  end

  defp data(nil = _url), do: nil

  defp render_short_link(token), do: Shortener.build_link(token)
end
