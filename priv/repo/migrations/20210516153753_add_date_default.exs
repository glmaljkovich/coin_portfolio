defmodule CoinPortfolio.Repo.Migrations.AddDateDefault do
  use Ecto.Migration

  def change do
    alter table("transactions") do
      modify :date, :string, default: "2021-05-15T00:00:00Z"
    end
  end
end
