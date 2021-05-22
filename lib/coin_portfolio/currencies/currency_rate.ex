defmodule CoinPortfolio.Currencies.CurrencyRate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "currency_rates" do
    field :base_currency, :string
    field :rate, :float
    field :target_currency, :string
    field :timestamp, :string

    timestamps()
  end

  @doc false
  def changeset(currency_rate, attrs) do
    currency_rate
    |> cast(attrs, [:base_currency, :target_currency, :rate, :timestamp])
    |> validate_required([:base_currency, :target_currency, :rate, :timestamp])
  end
end
