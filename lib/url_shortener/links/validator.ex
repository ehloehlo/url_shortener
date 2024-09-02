defmodule UrlShortener.Links.Validator do
  @moduledoc """
  Validates URLs stucture
  """

  import Ecto.Changeset

  @checks [:nonempty_string, :uri_parsed, :match_url_regex]

  @url_regex ~r/http[s]?:\/\/(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\(\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+/

  @spec validate_url(any(), any(), any()) :: any()
  def validate_url(changeset, fields, opts \\ []) do
    fields_with_errors =
      for field <- fields,
          !valid_url?(get_field(changeset, field)),
          do: field

    case fields_with_errors do
      [] ->
        changeset

      _ ->
        msg = message(opts, "invalid URL format")
        new_errors = Enum.map(fields_with_errors, &{&1, {msg, [validation: :url]}})
        changes = Map.drop(changeset.changes, fields_with_errors)

        %{
          changeset
          | changes: changes,
            errors: new_errors ++ changeset.errors,
            valid?: false
        }
    end
  end

  defp valid_url?(value) do
    Enum.all?(@checks, &do_validate_url(value, &1))
  end

  defp do_validate_url(value, :nonempty_string) when is_binary(value), do: value != ""
  defp do_validate_url(_value, :nonempty_string), do: false

  defp do_validate_url(value, :uri_parsed) do
    case URI.new(value) do
      {:ok, _} -> true
      _ -> false
    end
  end

  defp do_validate_url(value, :match_url_regex), do: String.match?(value, @url_regex)

  defp message(opts, key \\ :message, default) do
    Keyword.get(opts, key, default)
  end
end
