defmodule CoinPortfolio.Currencies do
  @moduledoc """
  The Currencies context.
  """

  import Ecto.Query, warn: false
  alias CoinPortfolio.Repo

  alias CoinPortfolio.Currencies.CurrencyRate

  @doc """
  Returns the list of currency_rates.

  ## Examples

      iex> list_currency_rates()
      [%CurrencyRate{}, ...]

  """
  def list_currency_rates do
    Repo.all(CurrencyRate)
  end

  @doc """
  Returns the latest currency_rates by timestamp.
  """
  def latest_currency_rates do
    latest_rates_query = from r1 in CurrencyRate,
      select: %{
        base_currency: r1.base_currency,
        target_currency: r1.target_currency,
        max_timestamp: max(r1.timestamp)
      },
      group_by: [r1.base_currency, r1.target_currency]
    query = from(
      r2 in CurrencyRate,
      inner_join: r1 in subquery(latest_rates_query),
      on: r1.base_currency == r2.base_currency and r1.target_currency == r2.target_currency and r1.max_timestamp == r2.timestamp
    )
    Repo.all(query)
  end

  @doc """
  Deletes all currency rates older than 24hs.
  This is to comply with https://www.exchangerate-api.com/terms
  """
  def purge_currency_rates do
    last_24_hs = DateTime.utc_now() |> DateTime.add(-60 * 60 * 24, :second) |> DateTime.to_iso8601()
    query = from r1 in CurrencyRate,
      where: r1.timestamp < ^last_24_hs
    Repo.delete_all(query)
  end

  @doc """
  Gets a single currency_rate.

  Raises `Ecto.NoResultsError` if the Currency rate does not exist.

  ## Examples

      iex> get_currency_rate!(123)
      %CurrencyRate{}

      iex> get_currency_rate!(456)
      ** (Ecto.NoResultsError)

  """
  def get_currency_rate!(id), do: Repo.get!(CurrencyRate, id)

  @doc """
  Creates a currency_rate.

  ## Examples

      iex> create_currency_rate(%{field: value})
      {:ok, %CurrencyRate{}}

      iex> create_currency_rate(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_currency_rate(attrs \\ %{}) do
    %CurrencyRate{}
    |> CurrencyRate.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a currency_rate.

  ## Examples

      iex> update_currency_rate(currency_rate, %{field: new_value})
      {:ok, %CurrencyRate{}}

      iex> update_currency_rate(currency_rate, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_currency_rate(%CurrencyRate{} = currency_rate, attrs) do
    currency_rate
    |> CurrencyRate.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a currency_rate.

  ## Examples

      iex> delete_currency_rate(currency_rate)
      {:ok, %CurrencyRate{}}

      iex> delete_currency_rate(currency_rate)
      {:error, %Ecto.Changeset{}}

  """
  def delete_currency_rate(%CurrencyRate{} = currency_rate) do
    Repo.delete(currency_rate)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking currency_rate changes.

  ## Examples

      iex> change_currency_rate(currency_rate)
      %Ecto.Changeset{data: %CurrencyRate{}}

  """
  def change_currency_rate(%CurrencyRate{} = currency_rate, attrs \\ %{}) do
    CurrencyRate.changeset(currency_rate, attrs)
  end
end
