defmodule CoinPortfolioWeb.IndexLive do
  use CoinPortfolioWeb, :live_view
  alias CoinPortfolio.Transactions
  alias CoinPortfolio.Tokens
  alias CoinPortfolio.Balances
  import CoinPortfolio.Utils.TransactionUtils

  @impl true
  def mount(_params, session, socket) do
    {:ok, fetch(socket, session)}
  end

  def fetch(socket, session) do
    updated_socket =
      socket
      |> assign(:current_user, session["current_user"])
      |> fetch_transactions_and_rates()
    current_user = if updated_socket == nil, do: nil, else: updated_socket.assigns.current_user
    if current_user do
      assign(updated_socket, :transactions, Transactions.find_transactions(current_user.email))
    else
      updated_socket
    end
  end

  def fetch_transactions_and_rates(socket) do
    current_user = socket.assigns.current_user
    thirty_days_back = DateTime.to_iso8601(DateTime.add(DateTime.now!("Etc/UTC"), -30 * 24 * 60 * 60, :second))
    accepted_tokens = Application.get_env(:coin_portfolio, :accepted_tokens)
    accepted_currencies = Application.get_env(:coin_portfolio, :accepted_currencies)
    if current_user do
      transactions = Transactions.find_transactions(current_user.email)
      rates = get_rates(Tokens.latest_rates(), current_user.main_currency)
      socket
      |> assign(:rates, rates)
      |> assign(:accepted_tokens, accepted_tokens)
      |> assign(:accepted_currencies, accepted_currencies)
      |> assign(:transactions, Transactions.find_transactions(current_user.email))
      |> assign(:token_names, token_symbol_name_map())
      |> assign(:assets, Transactions.holdings_by_token(current_user))
      |> assign(:balance_history, Balances.balances_for_user(current_user.email, thirty_days_back, transactions, rates))
    else
      socket
    end
  end

  def handle_event("add", %{"transaction" => transaction}, socket) do
    current_user = socket.assigns.current_user
    Transactions.create_transaction(transaction, current_user)

    {:noreply, redirect(socket, to: "/")}
  end

  def handle_event("delete", %{"transactionid" => transactionId, "value" => _value}, socket) do
    Transactions.delete_transaction(%Transactions.Transaction{:id => String.to_integer(transactionId)})
    {:noreply, redirect(socket, to: "/")}
  end

end
