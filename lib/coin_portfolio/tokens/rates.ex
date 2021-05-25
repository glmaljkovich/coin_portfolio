defmodule CoinPortfolio.Tokens.Rates do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rates" do
    field :currency, :string
    field :rate, :float
    field :timestamp, :string
    field :token, :string
    field :token_name, :string
    field :cmc_id, :integer
    field :percent_change_24h, :float
    field :percent_change_7d, :float

    timestamps()
  end

  @doc false
  def changeset(rates, attrs) do
    rates
    |> cast(attrs, [:token, :token_name, :currency, :rate, :timestamp, :cmc_id, :percent_change_24h, :percent_change_7d])
    |> validate_required([:token, :token_name, :currency, :rate, :timestamp])
  end
end
