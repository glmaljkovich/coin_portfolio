defmodule CoinPortfolioWeb.IndexLive do
  use CoinPortfolioWeb, :live_view
  alias CoinPortfolio.Transactions
  alias CoinPortfolio.Tokens

  @ars_taxes_factor 1.7498
  @ars "ARS"

  @impl true
  def mount(_params, session, socket) do
    {:ok, fetch(socket, session)}
  end

  def fetch(socket, session) do
    updated_socket = assign(socket, :current_user, session["current_user"])
    updated_socket = fetch_transactions_and_rates(updated_socket)
    current_user = updated_socket.assigns.current_user
    if current_user do
      assign(updated_socket, :transactions, Transactions.find_transactions(current_user.email))
    end
  end

  def fetch_transactions_and_rates(socket) do
    current_user = socket.assigns.current_user
    if current_user do
      rates = get_rates(Tokens.latest_rates(), current_user.main_currency)
      # rates = %{
      #   "BTC" => 4591940.477629449,
      #   "BUSD" => 94.01303037087888,
      #   "DAI" => 93.93525667424039,
      #   "DOGE" => 47.91499981832192,
      #   "ETH" => 342788.823086309
      # }
      rates = for {token, rate} <- rates, into: %{}, do: {token, (if current_user.main_currency == @ars, do: rate * @ars_taxes_factor, else: rate)}
      socket
      |> assign(:rates, rates)
      |> assign(:transactions, Transactions.find_transactions(current_user.email))
      |> assign(:token_names, token_symbol_name_map())
    end
  end

  @impl true
  def handle_event("add", %{"transaction" => transaction}, socket) do
    current_user = socket.assigns.current_user
    transaction_augmented = Map.merge(key_to_atom(transaction), %{:user => current_user.email})
    transaction_augmented = Map.put(transaction_augmented, :token, String.upcase(transaction_augmented.token))
    Transactions.create_transaction(transaction_augmented)

    {:noreply, fetch_transactions_and_rates(socket)}
  end

  def handle_event("delete", %{"transactionid" => transactionId, "value" => _value}, socket) do
    Transactions.delete_transaction(%Transactions.Transaction{:id => String.to_integer(transactionId)})

    {:noreply, fetch_transactions_and_rates(socket)}
  end

  def get_rates(rates, _main_currency) do
    for rate <- rates, into: %{}, do: {rate.token, rate.rate}
  end

  def to_precision(val, decimals) do
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

  def total_holdings_in_main_currency(transactions, rates) do
    Enum.reduce(transactions, 0.00,
      fn transaction, total ->
        rate = rates[String.upcase(transaction.token)]
        (transaction.token_amount * rate) + total
      end
    )
  end

  def get_holdings_color(transactions, rate) do
    holdings = total_holdings_in_main_currency(transactions, rate)
    spent = total_main_currency_spent(transactions)
    if holdings > spent, do: "green", else: "red"
  end

  def token_symbol_name_map do
    %{
      "ETH" => "ethereum",
      "BTC" => "bitcoin",
      "DAI" => "dai",
      "DOGE" => "dogecoin",
      "BUSD" => "busd"
    }
  end

  def holdings_percentage(transactions, rates) do
    holdings = total_holdings_in_main_currency(transactions, rates)
    spent = total_main_currency_spent(transactions)
    change = holdings - spent
    to_precision(change / spent * 100, 1)
  end

  def pretty_transaction_date(date) do
    {:ok, datetime, _ignore} = DateTime.from_iso8601(date)
    Calendar.strftime(datetime, "%a, %B %d %Y")
  end

end
