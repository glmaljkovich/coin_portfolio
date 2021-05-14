defmodule CoinPortfolio.Repo.Migrations.CreateRates do
  use Ecto.Migration

  def change do
    create table(:rates) do
      add :token, :string
      add :token_name, :string
      add :currency, :string
      add :rate, :float
      add :timestamp, :string

      timestamps()
    end

  end
end
