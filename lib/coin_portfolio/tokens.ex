defmodule CoinPortfolio.Tokens do
  @moduledoc """
  The Tokens context.
  """

  import Ecto.Query, warn: false
  alias CoinPortfolio.Repo

  alias CoinPortfolio.Tokens.Rates

  @doc """
  Returns the list of rates.

  ## Examples

      iex> list_rates()
      [%Rates{}, ...]

  """
  def list_rates do
    Repo.all(Rates)
  end

  def latest_rates do
    latest_rates_query = from r1 in Rates,
      select: %{token: r1.token, currency: r1.currency, max_timestamp: max(r1.timestamp)},
      group_by: [r1.token, r1.currency]
    query = from(r2 in Rates, inner_join: r1 in subquery(latest_rates_query), on: r1.token == r2.token and r1.currency == r2.currency and r1.max_timestamp == r2.timestamp )
    Repo.all(query)
  end

  @doc """
  Deletes all rates older than 24hs.
  This is to avoid reaching Heroku Postgres hobby-dev DB quota so fast
  """
  def purge_rates do
    last_24_hs = DateTime.utc_now() |> DateTime.add(-60 * 60 * 24, :second) |> DateTime.to_iso8601()
    query = from r1 in Rates,
      where: r1.timestamp < ^last_24_hs
    Repo.delete_all(query)
  end

  @doc """
  Gets a single rates.

  Raises `Ecto.NoResultsError` if the Rates does not exist.

  ## Examples

      iex> get_rates!(123)
      %Rates{}

      iex> get_rates!(456)
      ** (Ecto.NoResultsError)

  """
  def get_rates!(id), do: Repo.get!(Rates, id)

  @doc """
  Creates a rates.

  ## Examples

      iex> create_rates(%{field: value})
      {:ok, %Rates{}}

      iex> create_rates(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_rates(attrs \\ %{}) do
    %Rates{}
    |> Rates.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a rates.

  ## Examples

      iex> update_rates(rates, %{field: new_value})
      {:ok, %Rates{}}

      iex> update_rates(rates, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_rates(%Rates{} = rates, attrs) do
    rates
    |> Rates.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a rates.

  ## Examples

      iex> delete_rates(rates)
      {:ok, %Rates{}}

      iex> delete_rates(rates)
      {:error, %Ecto.Changeset{}}

  """
  def delete_rates(%Rates{} = rates) do
    Repo.delete(rates)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking rates changes.

  ## Examples

      iex> change_rates(rates)
      %Ecto.Changeset{data: %Rates{}}

  """
  def change_rates(%Rates{} = rates, attrs \\ %{}) do
    Rates.changeset(rates, attrs)
  end
end
