defmodule CoinPortfolio.Repo.Migrations.AddDateToTransaction do
  use Ecto.Migration

  def change do
    alter table("transactions") do
      add :date, :string
    end
  end
end
