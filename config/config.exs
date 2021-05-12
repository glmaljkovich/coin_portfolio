# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :coin_portfolio,
  ecto_repos: [CoinPortfolio.Repo]

# Configures the endpoint
config :coin_portfolio, CoinPortfolioWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "FpKz4keSHhWlDHH0pARWaPo3O1W0ekiSurxH38Hvaiq53hqeOcKROgelKyNEZSri",
  render_errors: [view: CoinPortfolioWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: CoinPortfolio.PubSub,
  live_view: [signing_salt: "V8PfEpTX"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
