defmodule LunchrInterface.PageControllerTest do
  use LunchrInterface.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Hello Lunchr!"
  end
end
