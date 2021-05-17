defmodule CoinPortfolio.Repo.Migrations.DropTransactionType do
  use Ecto.Migration

  def change do
    alter table("transactions") do
      remove :transaction_type
    end
  end
end
