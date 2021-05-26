defmodule CoinPortfolio.Scheduler.PurgeRates do
  alias CoinPortfolio.Tokens
  def run() do
    IO.puts "Purging rates..."
    Tokens.purge_rates()
    IO.puts "Done purging."
  end
end
