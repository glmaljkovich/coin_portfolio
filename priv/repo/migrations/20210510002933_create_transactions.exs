defmodule CoinPortfolio.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :user, :string
      add :main_currency, :string
      add :currency_amount, :float
      add :token, :string
      add :token_amount, :float

      timestamps()
    end

  end
end
