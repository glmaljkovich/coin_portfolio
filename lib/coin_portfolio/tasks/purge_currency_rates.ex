defmodule CoinPortfolio.Scheduler.PurgeCurrencyRates do
  alias CoinPortfolio.Currencies
  def run() do
    IO.puts "Purging currency rates..."
    Currencies.purge_currency_rates()
    IO.puts "Done purging."
  end
end
