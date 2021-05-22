defmodule CoinPortfolio.Utils.TransactionUtils do
  @ars_taxes_factor 1.7498
  @ars "ARS"

  def get_rates_for_currency(rates, main_currency) do
    extracted_rates = for rate <- rates, into: %{}, do: {"#{rate.token}/#{rate.currency}", rate.rate}
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

  def total_main_currency_spent(transactions, currency_rates, current_user) do
    Enum.reduce(transactions, 0,
      fn transaction, total ->
        exchange_rate = get_exchange_rate(currency_rates, current_user, transaction)
        if transaction.type == "buy" do
          (transaction.currency_amount * exchange_rate.rate) + total
        else
          total - (transaction.currency_amount * exchange_rate.rate)
        end
      end
    )
  end

  def get_exchange_rate(currency_rates, current_user, transaction) do
    Enum.find(currency_rates,
      fn rate ->
        rate.base_currency == transaction.main_currency and rate.target_currency == current_user.main_currency
      end
    )
  end

  def total_holdings_in_main_currency(transactions, rates, currency_rates, current_user) do
    Enum.reduce(transactions, 0.00,
      fn transaction, total ->
        exchange_rate = get_exchange_rate(currency_rates, current_user, transaction)
        rate = rates["#{String.upcase(transaction.token)}/#{transaction.main_currency}"]
        if transaction.type == "buy" do
          (transaction.token_amount * rate * exchange_rate.rate) + total
        else
          total - (transaction.token_amount * rate * exchange_rate.rate)
        end
      end
    )
  end

  def get_holdings_color(holdings, spent) do
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

  def holdings_percentage(holdings, spent) do
    change = holdings - spent
    if spent > 0 do
      to_precision(change / spent * 100, 1)
    else
      "0"
    end
  end

  def pretty_transaction_date(date) do
    {:ok, datetime, _ignore} = DateTime.from_iso8601(date)
    Calendar.strftime(datetime, "%a, %B %d %Y")
  end

  def token_to_main_currency(asset, rates, current_user) do
    to_precision(asset.total * rates["#{asset.token}/#{current_user.main_currency}"], 2)
  end

  def balance_history_to_chart_data(balance_history) do
    balance_history
    |> Enum.map(
      fn balance ->
        {:ok, date, _ignore} = DateTime.from_iso8601(balance.timestamp)
        %{"x" => DateTime.to_unix(date, :millisecond), "y" => balance.holdings}
      end
    )
    |> Poison.encode!()
  end

  def to_money(amount, current_user, symbol \\ false) do
    Money.to_string(Money.parse!(amount, String.to_atom(current_user.main_currency)), symbol: symbol)
  end

  def currency_from_rate(token) do
    Enum.at(String.split(token, "/"), 1)
  end
end
