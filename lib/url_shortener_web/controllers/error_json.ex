defmodule UrlShortenerWeb.Api.ErrorJsonView do
  def render("422.json", %{changeset: changeset}) do
    %{
      errors:
        Ecto.Changeset.traverse_errors(
          changeset,
          fn {msg, opts} ->
            Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
              opts
              |> Keyword.get(String.to_existing_atom(key), key)
              |> to_string()
            end)
          end
        )
    }
  end
end
