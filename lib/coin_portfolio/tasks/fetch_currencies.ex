defmodule CoinPortfolio.Scheduler.FetchCurrencyRates do
  alias CoinPortfolio.Currencies
  def run() do
    IO.puts "Fetching currency rates..."
    exchange_rate_api_key = Application.get_env(:coin_portfolio, :exchange_rate_api_key)
    accepted_currencies = Application.get_env(:coin_portfolio, :accepted_currencies)

    for base_currency <- accepted_currencies do
      url = "https://v6.exchangerate-api.com/v6/#{exchange_rate_api_key}/latest/#{base_currency}"
      {:ok, %HTTPoison.Response{ body: body }} = HTTPoison.get(url)
      rates = Jason.decode!(body)
      for {target_currency, rate} <- rates["conversion_rates"] do
        record = %{
          "base_currency" => base_currency,
          "target_currency" => target_currency,
          "rate" => rate,
          "timestamp" => rates["time_last_update_unix"]
                          |> DateTime.from_unix!()
                          |> DateTime.to_iso8601()
        }
        Currencies.create_currency_rate(record)
        IO.puts "Created rate for #{base_currency} to #{target_currency}"
      end
    end
  end
end
