defmodule BankApp.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string, null: false
    field :status, :boolean, default: true
    field :balance, :float, default: 0.0

    timestamps()
  end

  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:name, :status, :balance])
    |> validate_required([:name, :status, :balance])
  end
end
