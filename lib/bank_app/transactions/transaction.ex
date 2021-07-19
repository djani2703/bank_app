defmodule BankApp.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :uid, :integer, null: false
    field :type, :string, null: false
    field :amount, :float

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:uid, :type, :amount])
    |> validate_required([:uid, :type, :amount])
  end
end
