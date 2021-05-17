defmodule CoinPortfolio.Repo.Migrations.BackfillTransactionType do
  use Ecto.Migration

  def change do
    execute "UPDATE transactions SET transaction_type = 'buy' WHERE transaction_type is null"
  end
end
