defmodule CoinPortfolio.Repo.Migrations.AddTimestamp do
  use Ecto.Migration

  def change do
    alter table("currency_rates") do
      add :timestamp, :string
    end
  end
end
