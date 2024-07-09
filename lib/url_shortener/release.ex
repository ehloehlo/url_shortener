defmodule UrlShortener.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  installed.
  """
  @app :url_shortener

  @doc """
  Create DB if it doesn't exist yet
  """
  def init_db do
    case UrlShortener.Repo.config() |> Ecto.Adapters.Postgres.storage_up() do
      :ok ->
        Ecto.Migrator.run(UrlShortener.Repo, :up, all: true)

      error ->
        IO.puts("Error connecting to Posgres: #{inspect(error)}. Retring in 1 sec")
        Process.sleep(1000)
        init_db()
    end
  end

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end
end
