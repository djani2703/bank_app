defmodule BankAppWeb.UserController do
  use BankAppWeb, :controller

  alias BankApp.Users
  alias BankApp.Users.User

  def broadcast_msg!(conn, msg, route) do
    conn
    |> put_flash(:info, msg)
    |> redirect(to: Routes.user_path(conn, route))
  end

  def broadcast_msg!(conn, msg, route, data) do
    conn
    |> put_flash(:info, msg)
    |> redirect(to: Routes.user_path(conn, route, data))
  end

  def index(conn, _) do
    users = Users.get_all_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset, data: "new")
  end

  def create?(conn, %{"user" => %{"name" => name} = user_params}) do
    case Users.new_user?(name) do
      true ->
        create(conn, user_params)

      _ ->
        broadcast_msg!(conn, "User already exist..", :index)
    end
  end

  def create(conn, user_params) do
    case Users.create_user(user_params) do
      {:ok, user} ->
        broadcast_msg!(conn, "User created successfully!", :show, user)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def change_user(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)
    update(conn, user, user_params)
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def new_status?(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    changeset = User.changeset(user)
    render(conn, "update.html", user: user, changeset: changeset, data: "status")
  end

  def change_status(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)
    update(conn, user, user_params)
  end

  def balance_up(conn, %{"id" => id}) do
    can_change_balance?(conn, id, "up")
  end

  def balance_down(conn, %{"id" => id}) do
    can_change_balance?(conn, id, "down")
  end

  def can_change_balance?(conn, id, flag) do
    user = Users.get_user!(id)

    case Map.get(user, :status) do
      true ->
        changeset = User.changeset(user)
        render(conn, "update.html", user: user, changeset: changeset, data: flag)

      _ ->
        broadcast_msg!(conn, "Inactive user..", :show, user)
    end
  end

  def change_balance(conn, %{"id" => id, "user" => %{"up_balance" => up}}) do
    user = Users.get_user!(id)

    case Float.parse(up) do
      {up, _} ->
        update(conn, user, %{"balance" => Map.get(user, :balance) + up})
        Users.add_transaction_note(id, "deposit", up)

      :error ->
        broadcast_msg!(conn, "Incorrect up balance data: #{up}..", :show, user)
    end
  end

  def change_balance(conn, %{"id" => id, "user" => %{"down_balance" => down}}) do
    user = Users.get_user!(id)

    case Float.parse(down) do
      {down, _} ->
        can_withdraw?(conn, user, down)

      :error ->
        broadcast_msg!(conn, "Incorrect down balance data: #{down}..", :show, user)
    end
  end

  def can_withdraw?(conn, %{:balance => balance, :id => id} = user, amount) do
    new_balance = balance - amount

    case new_balance >= 0 do
      true ->
        update(conn, user, %{"balance" => new_balance})
        Users.add_transaction_note(id, "withdraw", amount)

      _ ->
        broadcast_msg!(conn, "Not enough money to withdraw..", :show, user)
    end
  end

  def update(conn, user, user_params) do
    case Users.update_user(user, user_params) do
      {:ok, user} ->
        broadcast_msg!(conn, "User updated successfully!", :show, user)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end
end
