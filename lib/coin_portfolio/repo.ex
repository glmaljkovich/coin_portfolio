defmodule CoinPortfolio.Repo do
  use Ecto.Repo,
    otp_app: :coin_portfolio,
    adapter: Ecto.Adapters.Postgres
end
