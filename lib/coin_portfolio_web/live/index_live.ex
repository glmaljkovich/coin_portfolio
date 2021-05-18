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
    updated_socket = assign(socket, :current_user, session["current_user"])
    updated_socket = fetch_transactions_and_rates(updated_socket)
    current_user = updated_socket.assigns.current_user
    if current_user do
      assign(updated_socket, :transactions, Transactions.find_transactions(current_user.email))
    end
  end

  def fetch_transactions_and_rates(socket) do
    current_user = socket.assigns.current_user
    thirty_days_back = DateTime.to_iso8601(DateTime.add(DateTime.now!("Etc/UTC"), -30 * 24 * 60 * 60, :second))
    if current_user do
      rates = get_rates(Tokens.latest_rates(), current_user.main_currency)
      socket
      |> assign(:rates, rates)
      |> assign(:transactions, Transactions.find_transactions(current_user.email))
      |> assign(:token_names, token_symbol_name_map())
      |> assign(:assets, Transactions.holdings_by_token(current_user))
      |> assign(:balance_history, Balances.balances_for_user(current_user.email, thirty_days_back))
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

end
