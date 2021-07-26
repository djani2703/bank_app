defmodule BankAppWeb.TransactionControllerTest do
  use BankAppWeb.ConnCase

  test "get all transactions", %{conn: conn} do
    conn = get(conn, Routes.transaction_path(conn, :index))
    assert html_response(conn, 200) =~ "Transactions:"
  end
end
