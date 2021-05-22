defmodule CoinPortfolio.Repo.Migrations.CreateCurrencyRates do
  use Ecto.Migration

  def change do
    create table(:currency_rates) do
      add :base_currency, :string
      add :target_currency, :string
      add :rate, :float

      timestamps()
    end

  end
end
