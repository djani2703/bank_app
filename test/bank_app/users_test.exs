defmodule BankApp.UsersTest do
  use BankApp.DataCase

  alias BankApp.Users.User
  alias BankApp.Users
  alias BankApp.Transactions.Transaction

  describe "users" do
    @valid_attrs %{name: "Oliver", status: true, balance: 150.9}
    @invalid_attrs %{name: nil, status: nil, balance: nil}
    @update_attrs %{name: "Charlotte", status: false, balance: 459.99}

    def test_user(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Users.create_user()

      user
    end

    test "get_user!/1 returns user by id" do
      user = test_user()
      assert Users.get_user!(user.id) == user
    end

    test "get_all_users/0 returns list of users" do
      user = test_user()
      assert Users.get_all_users() == [user]
    end

    test "new_user?/1 checks if the user is new" do
      user = test_user()
      assert Users.new_user?(user.name) == false
    end

    test "create_user/1 with valid data creates a user" do
      {:ok, %User{} = user} = Users.create_user(@valid_attrs)
      assert user.name == "Oliver"
      assert user.status == true
      assert user.balance == 150.9
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = test_user()
      assert {:ok, %User{} = user} = Users.update_user(user, @update_attrs)
      assert user.name == "Charlotte"
      assert user.status == false
      assert user.balance == 459.99
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = test_user()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      assert user == Users.get_user!(user.id)
    end

    test "add_transaction_note/3 with valid data insert row note into table" do
      user = test_user()
      assert {:ok, %Transaction{}} = Users.add_transaction_note(user.id, "deposit", 60.0)
    end

    test "add_transaction_note/3 with invalid data returns error changeset" do
      user = test_user()
      assert {:error, %Ecto.Changeset{}} = Users.add_transaction_note(user.id, nil, nil)
    end
  end
end
