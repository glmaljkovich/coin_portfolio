defmodule CoinPortfolio.Scheduler.FetchRates do
  alias CoinPortfolio.Tokens
  def run() do
    IO.puts "Fetching rates..."
    cmc_api_key = Application.get_env(:coin_portfolio, :cmc_api_key)
    base_currency = Application.get_env(:coin_portfolio, :base_currency)
    tokens =
      Application.get_env(:coin_portfolio, :accepted_tokens)
      |> Enum.join(",")
    url = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest?symbol=#{tokens}&convert=#{base_currency}&CMC_PRO_API_KEY=#{cmc_api_key}"
    {:ok, %HTTPoison.Response{ body: body }} = HTTPoison.get(url)
    rates = Jason.decode!(body)
    for {token, rate} <- rates["data"] do
      for {currency, price} <- rate["quote"] do
        record = %{
          "token" => token,
          "token_name" => rate["name"],
          "rate" => price["price"],
          "currency" => currency,
          "timestamp" => price["last_updated"]
        }
        Tokens.create_rates(record)
        IO.puts "Created rate for token #{token}"
      end
    end
  end
end
