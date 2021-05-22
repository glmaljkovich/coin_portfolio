defmodule CoinPortfolio.Scheduler.BalanceSnapshot do
  alias CoinPortfolio.Accounts
  alias CoinPortfolio.Balances
  alias CoinPortfolio.Transactions
  alias CoinPortfolio.Tokens
  alias CoinPortfolio.Currencies

  import CoinPortfolio.Utils.TransactionUtils

  def run() do
    IO.puts "Taking balance snapshots..."
    users = Accounts.list_users()
    rates_list = Tokens.latest_rates()
    for user <- users do
      rates = get_rates_for_currency(rates_list, user.main_currency)
      transactions = Transactions.find_transactions(user.email)
      currency_rates = Currencies.latest_currency_rates()
      holdings = total_holdings_in_main_currency(transactions, rates, currency_rates, user)
      spent = total_main_currency_spent(transactions, currency_rates, user)
      change = holdings - spent
      change_percentage = to_precision(change / spent * 100, 1)
      record = %{
        "user" => user.email,
        "holdings" => holdings,
        "spent" => spent,
        "change_percentage" => change_percentage,
        "timestamp" => DateTime.to_iso8601(DateTime.now!("Etc/UTC"))
      }
      Balances.create_balance(record)
      IO.puts "Created balance snapshot for user #{user.email}"
    end
  end
end
