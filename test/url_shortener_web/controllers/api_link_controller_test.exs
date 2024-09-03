defmodule UrlShortenerWeb.Api.LinkControllerTest do
  use UrlShortenerWeb.ConnCase

  import UrlShortener.LinksFixtures

  alias UrlShortener.Links.Link

  defp setup_original_url(_context), do: %{original_url: original_url()}

  describe "POST /api/v1/url" do
    setup [:setup_original_url]

    test "creates a shortcut for a valid link", %{conn: conn, original_url: original_url} do
      conn = post(conn, ~p"/api/v1/url", %{url: original_url})

      assert resp = json_response(conn, 200)

      assert %{
               "link" => %{
                 "url" => ^original_url,
                 "shortLink" => "http://localhost" <> _,
                 "views" => 0
               }
             } = resp
    end

    test "returns error for an invalid link", %{conn: conn} do
      url = "broken url"

      conn = post(conn, ~p"/api/v1/url", %{url: url})

      assert json_response(conn, 422) == %{
               "errors" => %{"url" => ["invalid URL format"]}
             }
    end
  end

  defp create_short_link(_context) do
    %{existing_link: link_fixture()}
  end

  describe "GET /api/v1/url" do
    setup [:create_short_link]

    test "returns a shortcut if link exists", %{conn: conn, existing_link: link} do
      short_link = get_short_link(%Link{token: link.token})

      conn = get(conn, ~p"/api/v1/url", %{shortLink: short_link})

      assert json_response(conn, 200) == %{
               "link" => %{
                 "url" => link.url,
                 "views" => link.views,
                 "shortLink" => short_link
               }
             }
    end

    test "returns `null` if no links found", %{conn: conn} do
      conn = get(conn, ~p"/api/v1/url", %{shortLink: "http://localhost/missing"})

      assert json_response(conn, 200) == %{"link" => nil}
    end
  end
end
