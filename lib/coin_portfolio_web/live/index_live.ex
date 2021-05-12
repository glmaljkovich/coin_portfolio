defmodule CoinPortfolioWeb.IndexLive do
  use CoinPortfolioWeb, :live_view
  alias CoinPortfolio.Transactions

  @impl true
  def mount(_params, session, socket) do
    {:ok, fetch(socket, session)}
  end

  def fetch(socket, session) do
    updated_socket = assign(socket, :current_user, session["current_user"])
    updated_socket = fetch_transactions_and_rates(updated_socket)
    current_user = updated_socket.assigns.current_user
    assign(updated_socket, :transactions, Transactions.find_transactions(current_user.email))
  end

  def fetch_transactions_and_rates(socket) do
    current_user = socket.assigns.current_user
    url = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest?symbol=BTC,ETH&convert=ARS&CMC_PRO_API_KEY=#{current_user.cmc_api_key}"
    {:ok, %HTTPoison.Response{ body: body }} = HTTPoison.get(url)
    rates = Jason.decode!(body)
    #rates = %{"data" => %{"BTC" => %{"quote" => %{"ARS" => %{ "price" => 5324769.000}}}}}
    updated_socket = assign(socket, :rates, rates)
    assign(updated_socket, :transactions, Transactions.find_transactions(current_user.email))
  end

  @impl true
  def handle_event("add", %{"transaction" => transaction}, socket) do
    current_user = socket.assigns.current_user
    transaction_augmented = Map.merge(key_to_atom(transaction), %{:user => current_user.email})
    Transactions.create_transaction(transaction_augmented)

    {:noreply, fetch_transactions_and_rates(socket)}
  end

  def handle_event("delete", %{"transactionid" => transactionId, "value" => _value}, socket) do
    Transactions.delete_transaction(%Transactions.Transaction{:id => String.to_integer(transactionId)})

    {:noreply, fetch_transactions_and_rates(socket)}
  end

  def get_rates(rates) do
    %{"data" => %{"BTC" => %{"quote" => %{"ARS" => %{ "price" => price}}}}} = rates
    price
  end

  def to_currency(val, decimals) do
    Float.to_string(val, decimals: decimals)
  end

  def key_to_atom(map) do
    Enum.reduce(map, %{}, fn
      # String.to_existing_atom saves us from overloading the VM by
      # creating too many atoms. It'll always succeed because all the fields
      # in the database already exist as atoms at runtime.
      {key, value}, acc when is_atom(key) -> Map.put(acc, key, value)
      {key, value}, acc when is_binary(key) -> Map.put(acc, String.to_existing_atom(key), value)
    end)
  end

  def total_main_currency_spent(transactions) do
    Enum.reduce(transactions, 0, fn transaction, total -> transaction.currency_amount + total end)
  end

  def total_holdings_in_main_currency(transactions, rate) do
    to_currency(Enum.reduce(transactions, 0, fn transaction, total -> (transaction.token_amount * rate) + total end), 2)
  end

end
