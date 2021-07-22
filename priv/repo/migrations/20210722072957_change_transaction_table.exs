defmodule BankApp.Repo.Migrations.ChangeTransactionTable do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      modify :uid, references(:users, on_delete: :nothing)
    end
  end
end
