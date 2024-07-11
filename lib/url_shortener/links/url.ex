defmodule UrlShortener.Links.Url do
  alias UrlShortener.Links.Validator
  use Ecto.Schema

  import Ecto.Changeset

  import Ecto.Query, only: [from: 2]

  @type t :: %__MODULE__{
          link: String.t(),
          token: String.t(),
          views: integer
        }

  @required_fields ~w(link token views)a

  schema "urls" do
    field :link, :string
    field :token, :string
    field :views, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(url \\ %__MODULE__{}, attrs \\ %{}) do
    url
    |> cast(attrs, [:link, :token, :views])
    |> validate_required(@required_fields)
    |> validate_length(:link, max: 512)
    |> Validator.validate_url([:link])
  end

  def by_token(query \\ __MODULE__, token),
    do: from(u in query, where: u.token == ^token)
end
