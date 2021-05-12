defmodule CoinPortfolio.Repo.Migrations.AddFieldsToUser do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :name, :string
      add :main_currency, :string
      add :cmc_api_key, :string
    end
  end
end
