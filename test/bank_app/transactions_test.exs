defmodule BankApp.TransactionsTest do
  use BankApp.DataCase

  alias BankApp.Transactions.Transaction
  alias BankApp.Transactions
  alias BankApp.Users

  describe "transactions" do
    @valid_user_attrs %{name: "Oliver", status: true, balance: 250.5}
    @valid_transaction_attrs %{type: "deposit", amount: 59.0}
    @invalid_transaction_attrs %{type: nil, amount: nil}

    def test_user(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_user_attrs)
        |> Users.create_user()

      user
    end

    def test_transaction(attrs \\ %{}) do
      user = test_user()

      {:ok, transaction} =
        attrs
        |> Enum.into(%{uid: user.id})
        |> Enum.into(@valid_transaction_attrs)
        |> Transactions.add_transaction()

      transaction
    end

    test "get_all_transactions/0 returns list of transactions" do
      transaction = test_transaction()
      assert Transactions.get_all_transactions() == [transaction]
    end

    test "add_transaction/1 with valid data insert a new transaction row" do
      %{id: uid} = test_user()

      params = Map.put(@valid_transaction_attrs, :uid, uid)
      assert {:ok, %Transaction{} = transaction} = Transactions.add_transaction(params)
      assert transaction.uid == uid
      assert transaction.type == "deposit"
      assert transaction.amount == 59.0
    end

    test "add_transaction/1 with invalid data returns error changeset" do
      %{id: uid} = test_user()

      params = Map.put(@invalid_transaction_attrs, :uid, uid)
      assert {:error, %Ecto.Changeset{}} = Transactions.add_transaction(params)
    end
  end
end
