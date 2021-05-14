defmodule CoinPortfolio.Scheduler.FetchRates do
  alias CoinPortfolio.Tokens
  def run() do
    IO.puts "Fetchin rates..."
    cmc_api_key = System.get_env("CMC_API_KEY")
    url = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest?symbol=BTC,ETH,DAI,BUSD,DOGE&convert=ARS&CMC_PRO_API_KEY=#{cmc_api_key}"
    {:ok, %HTTPoison.Response{ body: body }} = HTTPoison.get(url)
    IO.puts "Decoding body"
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
