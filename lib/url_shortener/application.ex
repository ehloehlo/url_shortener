defmodule UrlShortener.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      UrlShortenerWeb.Telemetry,
      UrlShortener.Repo,
      {DNSCluster, query: Application.get_env(:url_shortener, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: UrlShortener.PubSub},
      UrlShortener.RateLimit,
      UrlShortenerWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: UrlShortener.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    UrlShortenerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
