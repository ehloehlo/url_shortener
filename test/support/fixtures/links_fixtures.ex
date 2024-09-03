defmodule UrlShortener.LinksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `UrlShortener.Links` context.
  """

  alias UrlShortener.Links.Link

  alias UrlShortener.Repo

  import Ecto.Query, only: [from: 2]

  @original_url "https://www.youtube.com/watch?v=dQw4w9WgXcQ"

  @default_attrs %{
    url: @original_url,
    token: "ck62kROwdz8",
    views: 42
  }

  @doc """
  Generate a link.
  """
  def link_fixture(attrs \\ %{}) do
    attrs = Enum.into(attrs, @default_attrs)

    Link.changeset(%Link{}, attrs) |> Repo.insert!()
  end

  def get_short_link(%Link{token: token} = _link),
    do: "#{UrlShortenerWeb.Endpoint.static_url()}/#{token}"

  def get_link!(%Link{} = link), do: Repo.one!(from(l in Link, where: l.id == ^link.id))

  def original_url, do: @original_url
end
