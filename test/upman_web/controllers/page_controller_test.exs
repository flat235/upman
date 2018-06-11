defmodule UpmanWeb.PageControllerTest do
  use UpmanWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Upman"
  end
end
