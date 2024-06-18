defmodule UrlShortenerWeb.Api.ErrorJsonView do
  def render("422.json", %{changeset: changeset}) do
    # When encoded, the changeset returns its errors
    # as a JSON object. So we just pass it forward.
    %{errors: Ecto.Changeset.traverse_errors(
      changeset,
      fn {msg, opts} ->
         Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
           opts |> Keyword.get(String.to_existing_atom(key), key)
           |> to_string()
         end) end)}
  end
end
