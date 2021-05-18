defmodule CoinPortfolio.Repo.Migrations.RemoveBalanceToken do
  use Ecto.Migration

  def change do
    alter table("balances") do
      remove_if_exists :token, :string
    end
  end
end
