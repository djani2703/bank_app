defmodule BankApp.Users do
  import Ecto.Query, warn: false

  alias BankApp.Repo
  alias BankApp.Users.User
  alias BankApp.Transactions

  def get_user!(id) do
    Repo.get!(User, id)
  end

  def get_all_users() do
    Repo.all(User)
  end

  def new_user?(user_name) do
    get_all_users()
    |> Enum.map(fn %User{name: name} -> name end)
    |> Enum.member?(user_name)
    |> Kernel.not

  end

  def create_user(params \\ %{}) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
  end

  def update_user(%User{} = user, params) do
    user
    |> User.changeset(params)
    |> Repo.update()
  end

  def add_transaction_note(id, type, amount) do
    Transactions.add_transaction(
      %{uid: id, type: type, amount: amount}
    )
  end
end
