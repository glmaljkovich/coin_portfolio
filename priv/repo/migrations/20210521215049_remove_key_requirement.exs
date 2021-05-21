defmodule CoinPortfolio.Repo.Migrations.RemoveKeyRequirement do
  use Ecto.Migration

  def change do
    alter table("users") do
      remove :cmc_api_key
    end
  end
end
