defmodule UrlShortenerWeb.Api.FallbackController do
  use UrlShortenerWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: UrlShortenerWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(json: UrlShortenerWeb.ErrorJSON)
    |> render(:"404")
  end
end
