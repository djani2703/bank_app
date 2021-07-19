defmodule BankApp.Transactions do
  import Ecto.Query, warn: false

  alias BankApp.Repo
  alias BankApp.Transactions.Transaction

  def get_all_transactions() do
    Repo.all(Transaction)
  end

  def add_transaction(params \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(params)
    |> Repo.insert()
  end
end
