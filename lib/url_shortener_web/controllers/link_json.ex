defmodule UrlShortenerWeb.Api.LinkJSON do
  alias UrlShortener.Links
  alias UrlShortener.Links.Link

  def link(%{link: link}), do: %{link: data(link)}

  defp data(%Link{} = link) do
    %{
      url: link.url,
      views: link.views,
      shortLink: render_short_link(link.token)
    }
  end

  defp data(nil = _link), do: nil

  defp render_short_link(token), do: Links.build_link(token)
end
