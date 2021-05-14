defmodule CoinPortfolio.Tokens.Rates do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rates" do
    field :currency, :string
    field :rate, :float
    field :timestamp, :string
    field :token, :string
    field :token_name, :string

    timestamps()
  end

  @doc false
  def changeset(rates, attrs) do
    rates
    |> cast(attrs, [:token, :token_name, :currency, :rate, :timestamp])
    |> validate_required([:token, :token_name, :currency, :rate, :timestamp])
  end
end
