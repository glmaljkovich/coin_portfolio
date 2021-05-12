defmodule CoinPortfolioWeb.RatesController do
    use CoinPortfolioWeb, :controller

    def rates(conn, _params) do
      url = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest?symbol=BTC,ETH&convert=ARS&CMC_PRO_API_KEY=c8eb6917-bd5b-4c83-8520-a0b3208a7bc7"
      {:ok, %HTTPoison.Response{ body: body }} = HTTPoison.get(url)
      rates = Jason.decode!(body)
      assign(conn, :rates, rates)
      json(conn, rates)
    end
  end
