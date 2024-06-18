defmodule UrlFixture do
  import UrlShortener.Repo
  alias UrlShortener.Links.Url

  @original_link "https://www.youtube.com/watch?v=dQw4w9WgXcQ"

  @default_attrs [
    link: @original_link,
    token: "ck62kROwdz8",
    views: 42
  ]

  def create(attrs \\ []) do
    attrs = Keyword.merge(@default_attrs, attrs)

    Url
    |> struct(attrs)
    |> insert()
  end

  def original_link, do: @original_link
end
