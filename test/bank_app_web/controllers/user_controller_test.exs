defmodule BankAppWeb.UserControllerTest do
  use BankAppWeb.ConnCase

  alias BankApp.Users

  @valid_attrs %{name: "Alex", status: true, balance: 120.5}
  @invalid_attrs %{name: nil, status: nil, balance: nil}
  @update_attrs %{name: "Joseph", status: false, balance: 456.7}

  def test_user(attrs) do
    case Users.create_user(attrs) do
      {:ok, user} -> user
      _ = err -> err
    end
  end

  test "index", %{conn: conn} do
    conn = get(conn, Routes.user_path(conn, :index))
    assert html_response(conn, 200) =~ "All users:"
  end

  test "new user", %{conn: conn} do
    conn = get(conn, Routes.user_path(conn, :new))
    assert html_response(conn, 200) =~ "New user:"
  end

  test "create? checks if the user is new" do
    user = test_user(@valid_attrs)
    assert Users.new_user?(user.name) == false
  end

  test "create? with valid params creates new user", %{conn: conn} do
    conn = post(conn, Routes.user_path(conn, :create?), user: @valid_attrs)
    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == Routes.user_path(conn, :show, id)

    conn = get(conn, Routes.user_path(conn, :show, id))
    assert html_response(conn, 200) =~ "User created successfully!"
  end

  test "create? with invalid params returns error changeset", %{conn: conn} do
    conn = post(conn, Routes.user_path(conn, :create?), user: @invalid_attrs)
    assert html_response(conn, 200) =~ "Oops, something went wrong!"
  end

  test "change user with valid data returns updated user", %{conn: conn} do
    user = test_user(@valid_attrs)
    conn = put(conn, Routes.user_path(conn, :change_user, user), user: @update_attrs)
    assert redirected_to(conn) == Routes.user_path(conn, :show, user)

    conn = get(conn, Routes.user_path(conn, :show, user))
    assert html_response(conn, 200) =~ "User updated successfully!"
  end

  test "show user with valid params returns user info", %{conn: conn} do
    user = test_user(@valid_attrs)
    conn = get(conn, Routes.user_path(conn, :show, user.id))
    assert html_response(conn, 200) =~ "Show user:"
  end

  test "new status? returns the user with the new status", %{conn: conn} do
    user = test_user(@valid_attrs)
    conn = get(conn, Routes.user_path(conn, :new_status?, user.id))
    assert html_response(conn, 200) =~ "Change status:"
  end

  test "change status returns user with updated status", %{conn: conn} do
    user = test_user(@valid_attrs)
    conn = put(conn, Routes.user_path(conn, :change_status, user), user: %{status: false})
    assert get_flash(conn, "info") == "User updated successfully!"
  end

  test "change balance for an inactive user returns msg", %{conn: conn} do
    user = test_user(@update_attrs)
    conn = get(conn, Routes.user_path(conn, :balance_up, user.id))
    assert get_flash(conn, "info") == "Inactive user.."
  end

  test "balance up returns a user with a large balance", %{conn: conn} do
    user = test_user(@valid_attrs)
    conn = get(conn, Routes.user_path(conn, :balance_up, user.id))
    assert html_response(conn, 200) =~ "Up balance:"

    conn = put(conn, Routes.user_path(conn, :change_balance, user), user: %{up_balance: "50.0"})
    assert redirected_to(conn) == Routes.user_path(conn, :show, user.id)
    assert get_flash(conn, "info") == "User updated successfully!"
  end

  test "balance up with incorrect data returns error msg", %{conn: conn} do
    user = test_user(@valid_attrs)
    conn = put(conn, Routes.user_path(conn, :change_balance, user), user: %{up_balance: "asdf"})
    assert get_flash(conn, "info") == "Incorrect up balance data: asdf.."
  end

  test "balance down returns a user with a lower balance", %{conn: conn} do
    user = test_user(@valid_attrs)
    conn = get(conn, Routes.user_path(conn, :balance_down, user.id))
    assert html_response(conn, 200) =~ "Down balance:"

    conn = put(conn, Routes.user_path(conn, :change_balance, user), user: %{down_balance: "80.5"})
    assert redirected_to(conn) == Routes.user_path(conn, :show, user.id)
    assert get_flash(conn, "info") == "User updated successfully!"
  end

  test "balance down with incorrect data returns error msg", %{conn: conn} do
    user = test_user(@valid_attrs)
    conn = put(conn, Routes.user_path(conn, :change_balance, user), user: %{down_balance: "asdf"})
    assert get_flash(conn, "info") == "Incorrect down balance data: asdf.."
  end

  test "balance down with amount more than balance returns error msg", %{conn: conn} do
    user = test_user(@valid_attrs)
    conn = put(conn, Routes.user_path(conn, :change_balance, user), user: %{down_balance: "121.0"})
    assert get_flash(conn, "info") == "Not enough money to withdraw.."
  end
end
