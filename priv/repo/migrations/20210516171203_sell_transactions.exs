defmodule CoinPortfolio.Repo.Migrations.SellTransactions do
  use Ecto.Migration

  def change do
    alter table("transactions") do
      add :type, :string, default: "buy"
    end
  end
end
