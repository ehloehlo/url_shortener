defmodule UrlShortenerWeb.Api.UrlControllerTest do
  use UrlShortenerWeb.ConnCase

  import UrlFixture

  @token "link-token"
  @short_link "localhost/#{@token}"

  describe "POST /api/v1/url" do
    test "creates a shortcut for a valid link", %{conn: conn} do
      conn = post(conn, ~p"/api/v1/url", %{link: original_link()})

      assert resp = json_response(conn, 200)

      refute is_nil(resp["url"])

      assert resp["url"]["link"] == original_link()
      assert resp["url"]["shortLink"] =~ "localhost/"
      assert resp["url"]["views"] == 0
    end

    test "returns error for an invalid link", %{conn: conn} do
      link = "localhost:8888"

      conn = post(conn, ~p"/api/v1/url", %{link: link})

      assert json_response(conn, 422) ==  %{
        "errors" => %{"link" => ["Invalid URL format"]}
      }
    end
  end

  defp create_short_url(_context) do
    with {:ok, url} <- UrlFixture.create(token: @token) do
      %{existing_url: url}
    end
  end

  describe "GET /api/v1/url" do
    setup [:create_short_url]

    test "returns a shortcut if link exists", %{conn: conn, existing_url: url} do
      conn = get(conn, ~p"/api/v1/url", %{shortLink: @short_link})

      assert json_response(conn, 200) == %{
        "url" => %{
          "link" => url.link,
          "views" => url.views,
          "shortLink" => @short_link
        }
      }
    end

    test "returns `null` if no links found", %{conn: conn} do
      conn = get(conn, ~p"/api/v1/url", %{shortLink: "http://localhost/missing"})

      assert json_response(conn, 200) == %{"url" => nil}
    end
  end
end
