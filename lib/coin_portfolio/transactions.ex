defmodule CoinPortfolio.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  alias CoinPortfolio.Repo

  alias CoinPortfolio.Transactions.Transaction
  alias CoinPortfolio.EnumUtils

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transaction{}, ...]

  """
  def list_transactions do
    Repo.all(Transaction)
  end

  @doc """
  Returns the list of transactions for a user.
  """
  def find_transactions(user) do
    query = from transaction in Transaction, where: transaction.user == ^user
    Repo.all(query)
  end

  def holdings_by_token(user) do
    query = from t in Transaction,
      select: %{token: t.token, user: t.user, total: sum(t.token_amount)},
      where: t.user == ^user.email,
      group_by: [:token, :user]
    Repo.all(query)
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs \\ %{}, current_user) do
    cleaned_attrs = clean_transaction(attrs, current_user)
    %Transaction{}
    |> Transaction.changeset(cleaned_attrs)
    |> Repo.insert()
  end

  def clean_transaction(attrs, current_user) do
    transaction = EnumUtils.key_to_atom(attrs)
    transaction
    |> Map.merge(%{:user => current_user.email})
    |> Map.put(:token, String.upcase(transaction.token))
    |> Map.put(:currency, String.upcase(transaction.currency))
    |> Map.put(:date, "#{transaction.date}T00:00:00Z")
  end

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{data: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction, attrs \\ %{}) do
    Transaction.changeset(transaction, attrs)
  end
end
