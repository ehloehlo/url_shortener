defmodule UrlShortener.Repo.Migrations.AddTokenIndex do
  use Ecto.Migration

  def change do
    create unique_index(:urls, [:token])
  end
end
