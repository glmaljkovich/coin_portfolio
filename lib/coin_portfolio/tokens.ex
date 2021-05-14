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
