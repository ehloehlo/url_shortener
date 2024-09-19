defmodule UrlShortener.Links.Link do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  import Ecto.Query, only: [from: 2]

  alias __MODULE__

  alias UrlShortener.Links.Validator

  @type t :: %Link{
          url: String.t(),
          token: String.t(),
          views: pos_integer()
        }

  @required_fields ~w(url token views)a

  schema "links" do
    field :token, :string
    field :url, :string
    field :views, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(link \\ %Link{}, attrs \\ %{}) do
    link
    |> cast(attrs, [:url, :token, :views])
    |> validate_required(@required_fields)
    |> validate_length(:url, max: 1024)
    |> Validator.validate_url([:url])
    |> unique_constraint(:token)
  end

  def by_token(query \\ Link, token),
    do: from(u in query, where: u.token == ^token)
end
