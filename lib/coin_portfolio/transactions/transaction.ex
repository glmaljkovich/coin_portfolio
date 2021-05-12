defmodule CoinPortfolio.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :currency_amount, :float
    field :main_currency, :string
    field :token, :string
    field :token_amount, :float
    field :user, :string

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:user, :main_currency, :currency_amount, :token, :token_amount])
    |> validate_required([:user, :main_currency, :currency_amount, :token, :token_amount])
  end
end
