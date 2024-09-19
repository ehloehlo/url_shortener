defmodule UrlShortenerWeb.RedirectControllerTest do
  use UrlShortenerWeb.ConnCase

  alias UrlShortener.LinksFixtures
  alias UrlShortener.Links.Link

  import LinksFixtures

  describe "GET /some-token" do
    defp create_short_link(_context) do
      %{link: link_fixture()}
    end

    setup [:create_short_link]

    test "redirects for an existing short link", %{conn: conn, link: link} do
      conn = get(conn, get_short_link(link))

      assert redirected_to(conn) == link.url

      # wait for async increment views to complete
      async_task_pids = Task.Supervisor.children(UrlShortener.TaskSupervisor)

      for pid <- async_task_pids do
        ref = Process.monitor(pid)
        assert_receive {:DOWN, ^ref, _, _, _}
      end

      updated_link = get_link!(link)
      assert updated_link.views == link.views + 1
    end

    test "returns 404 if a short link is missing", %{conn: conn} do
      conn = get(conn, get_short_link(%Link{token: "missing"}))

      assert response(conn, 404)
    end
  end
end
