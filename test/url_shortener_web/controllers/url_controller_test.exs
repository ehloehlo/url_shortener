defmodule UrlShortenerWeb.UrlControllerTest do
  use UrlShortenerWeb.ConnCase

  alias UrlShortener.Links.Url
  import UrlFixture

  describe "GET /some-token" do
    defp create_short_link(_context) do
      with {:ok, link} <- UrlFixture.create() do
        %{link: link}
      end
    end

    setup [:create_short_link]

    test "redirects for an existing short link", %{conn: conn, link: link} do
      conn = get(conn, get_short_link(link))

      assert redirected_to(conn) == link.link
    end

    test "returns 404 if a short link is missing", %{conn: conn} do
      conn = get(conn, get_short_link(%Url{token: "missing"}))

      assert response(conn, 404)
    end
  end
end
