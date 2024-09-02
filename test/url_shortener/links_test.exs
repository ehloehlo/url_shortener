defmodule UrlShortener.LinksTest do
  use UrlShortener.DataCase

  alias UrlShortener.Links

  describe "links" do
    alias UrlShortener.Links.Link

    import UrlShortener.LinksFixtures

    test "get_by_short_link/1 returns the link with given id" do
      link = link_fixture()

      assert Links.get_by_short_link(link.token) == link
    end

    test "create_link/1 with valid data creates a link" do
      valid_url = "https://google.com/"

      assert {:ok, %Link{} = link} = Links.create_link(valid_url)
      assert link.url == valid_url
      assert link.views == 0
    end

    test "create_link/1 with invalid data returns error changeset" do
      invalid_url = "some-invalid-url"

      assert {:error, %Ecto.Changeset{}} = Links.create_link(invalid_url)
    end
  end
end
