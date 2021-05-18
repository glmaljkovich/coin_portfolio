defmodule CoinPortfolio.Repo.Migrations.CreateBalances do
  use Ecto.Migration

  def change do
    create table(:balances) do
      add :token, :string
      add :user, :string
      add :holdings, :float
      add :spent, :float
      add :change_percentage, :float
      add :timestamp, :string

      timestamps()
    end

  end
end
