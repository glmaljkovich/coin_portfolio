defmodule CoinPortfolio.Repo.Migrations.TransactionType do
  use Ecto.Migration

  def change do
    alter table("transactions") do
      add :transaction_type, :string, null: false, default: "buy"
    end
  end
end
