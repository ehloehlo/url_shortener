defmodule UrlShortener.Repo.Migrations.CreateUrls do
  use Ecto.Migration

  def change do
    create table(:urls) do
      add :link, :string, null: false
      add :token, :string, null: false
      add :views, :integer, null: false, default: 0

      timestamps(type: :utc_datetime)
    end
  end
end
