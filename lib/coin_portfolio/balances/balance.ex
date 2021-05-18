defmodule CoinPortfolio.Balances.Balance do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Poison.Encoder, only: [:change_percentage, :holdings, :timestamp, :spent, :user]}
  schema "balances" do
    field :change_percentage, :float
    field :holdings, :float
    field :spent, :float
    field :timestamp, :string
    field :user, :string

    timestamps()
  end

  @doc false
  def changeset(balance, attrs) do
    balance
    |> cast(attrs, [:user, :holdings, :spent, :change_percentage, :timestamp])
    |> validate_required([:user, :holdings, :spent, :change_percentage, :timestamp])
  end
end
