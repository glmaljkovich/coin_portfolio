defmodule CoinPortfolio.Repo.Migrations.BackfillDate do
  use Ecto.Migration

  def change do
    execute "UPDATE transactions SET date = '2021-05-15T00:00:00Z' WHERE date is null"
  end
end
