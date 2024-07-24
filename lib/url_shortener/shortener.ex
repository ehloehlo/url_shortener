defmodule UrlShortener.Shortener do
  alias UrlShortener.Repo
  alias UrlShortener.Links.Url

  @token_rnd_bytes 8

  @spec create_url(String.t()) :: {:ok, Url.t()} | {:error, Ecto.Changeset.t()}
  def create_url(link) do
    %Url{link: link, token: generate_token(), views: 0}
    |> Url.changeset()
    |> Repo.insert()
    |> case do
      {:ok, url} -> {:ok, url}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @spec get_by_short_link(String.t()) :: Url.t() | nil
  def get_by_short_link(short_link) do
    short_link
    |> extract_token_from_link()
    |> maybe_get_by_token()
  end

  @spec maybe_get_by_token(String.t() | nil) :: Url.t() | nil
  def maybe_get_by_token(nil), do: nil

  def maybe_get_by_token(token) do
    Url.by_token(token) |> Repo.one()
  end

  @spec increment_views(Url.t()) :: Url.t()
  def increment_views(url) do
    url
    |> Url.changeset(%{views: url.views + 1})
    |> Repo.update()
  end

  def build_link(token),
    do: "#{UrlShortenerWeb.Endpoint.static_url()}/#{token}"

  defp generate_token do
    :crypto.strong_rand_bytes(@token_rnd_bytes)
    |> Base.url_encode64(padding: false)
  end

  defp extract_token_from_link(short_link) do
    case URI.parse(short_link) do
      %URI{path: nil} -> :error
      %URI{path: token} -> String.trim(token, "/")
    end
  end
end
