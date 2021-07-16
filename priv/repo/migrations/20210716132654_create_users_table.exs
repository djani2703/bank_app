defmodule BankApp.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :status, :boolean, default: true
      add :balance, :float, defalut: 0.0

      timestamps()
    end
  end
end
