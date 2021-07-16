defmodule BankApp.Repo do
  use Ecto.Repo,
    otp_app: :bank_app,
    adapter: Ecto.Adapters.Postgres
end
