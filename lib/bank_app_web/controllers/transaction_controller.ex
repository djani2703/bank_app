defmodule BankAppWeb.TransactionController do
  use BankAppWeb, :controller

  alias BankApp.Transactions

  def index(conn, _) do
    transactions = Transactions.get_all_transactions()
    render(conn, "index.html", transactions: transactions)
  end
end
