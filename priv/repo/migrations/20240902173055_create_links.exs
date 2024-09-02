defmodule UrlShortener.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :url, :string, null: false
      add :token, :string, null: false
      add :views, :integer, null: false, default: 0

      timestamps(type: :utc_datetime)
    end

    create unique_index(:links, [:token])
  end
end
