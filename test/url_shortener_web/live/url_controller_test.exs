defmodule UrlShortenerWeb.Live.UrlControllerTest do
  use UrlShortenerWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "shorten_link"
  end
end
