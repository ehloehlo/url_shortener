defmodule UrlShortener.Links do
  @moduledoc """
  The module provides an interface for creating and expanding shortened URLs
  """

  import Ecto.Query, warn: false
  alias UrlShortener.Repo

  alias UrlShortener.Links.Link

  @token_rnd_bytes 8

  @doc "Creates a new link with 0 views"
  @spec create_link(String.t()) :: {:ok, Link.t()} | {:error, Ecto.Changeset.t()}
  def create_link(url) do
    %Link{url: url, token: generate_token(), views: 0}
    |> Link.changeset()
    |> Repo.insert()
  end

  @doc "Gets a link by its shortcut"
  @spec get_by_short_link(String.t()) :: Link.t() | nil
  def get_by_short_link(short_link) do
    short_link
    |> extract_token_from_link()
    |> maybe_get_by_token()
  end

  @spec maybe_get_by_token(String.t() | nil) :: Link.t() | nil
  def maybe_get_by_token(nil), do: nil

  def maybe_get_by_token(token) do
    Link.by_token(token) |> Repo.one()
  end

  @spec increment_views(Link.t()) :: Link.t()
  def increment_views(link) do
    link
    |> Link.changeset(%{views: link.views + 1})
    |> Repo.update()
  end

  defp generate_token do
    :crypto.strong_rand_bytes(@token_rnd_bytes)
    |> Base.url_encode64(padding: false)
  end

  def build_link(token),
    do: "#{UrlShortenerWeb.Endpoint.static_url()}/#{token}"

  defp extract_token_from_link(short_link) do
    case URI.parse(short_link) do
      %URI{path: nil} -> nil
      %URI{path: token} -> String.trim(token, "/")
    end
  end
end
