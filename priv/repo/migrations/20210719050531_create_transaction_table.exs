defmodule BankApp.Repo.Migrations.CreateTransactionTable do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :uid, :bigint, null: false
      add :type, :string, null: false
      add :amount, :float

      timestamps()
    end
  end
end
