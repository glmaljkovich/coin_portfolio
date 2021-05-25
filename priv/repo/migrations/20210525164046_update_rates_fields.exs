defmodule CoinPortfolio.Repo.Migrations.UpdateRatesFields do
  use Ecto.Migration

  def change do
    alter table("rates") do
      add :cmc_id, :integer
      add :percent_change_24h, :float
      add :percent_change_7d, :float
    end
  end
end
