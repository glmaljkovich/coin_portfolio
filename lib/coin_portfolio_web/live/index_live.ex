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
      socket
      |> assign(:rates, rates)
      |> assign(:transactions, Transactions.find_transactions(current_user.email))
      |> assign(:token_names, token_symbol_name_map())
      |> assign(:assets, Transactions.holdings_by_token(current_user))
    end
  end

  @impl true
  def handle_event("add", %{"transaction" => transaction}, socket) do
    current_user = socket.assigns.current_user
    Transactions.create_transaction(transaction, current_user)

    {:noreply, fetch_transactions_and_rates(socket)}
  end

  def handle_event("delete", %{"transactionid" => transactionId, "value" => _value}, socket) do
    Transactions.delete_transaction(%Transactions.Transaction{:id => String.to_integer(transactionId)})

    {:noreply, fetch_transactions_and_rates(socket)}
  end

  def get_rates(rates, main_currency) do
    extracted_rates = for rate <- rates, into: %{}, do: {rate.token, rate.rate}
    for {token, rate} <- extracted_rates,
      into: %{},
      do: {
        token,
        (if main_currency == @ars, do: rate * @ars_taxes_factor, else: rate)
      }
  end

  def to_precision(val, decimals) do
    Float.to_string(val, decimals: decimals)
  end

  def total_main_currency_spent(transactions) do
    Enum.reduce(transactions, 0,
      fn transaction, total ->
        if transaction.type == "buy" do
          transaction.currency_amount + total
        else
          total - transaction.currency_amount
        end
      end
    )
  end

  def total_holdings_in_main_currency(transactions, rates) do
    Enum.reduce(transactions, 0.00,
      fn transaction, total ->
        if transaction.type == "buy" do
          rate = rates[String.upcase(transaction.token)]
          (transaction.token_amount * rate) + total
        else
          total
        end
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

  def token_to_main_currency(asset, rates) do
    to_precision(asset.total * rates[asset.token], 2)
  end

end
