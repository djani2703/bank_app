defmodule BankAppWeb.PageControllerTest do
  use BankAppWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Greetings from the best bank in the world!"
  end
end
