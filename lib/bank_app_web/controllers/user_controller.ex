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

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def new_status?(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    changeset = User.changeset(user)
    render(conn, "update.html", user: user, changeset: changeset, data: "status")
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    case Users.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully!")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end
end
