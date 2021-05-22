defmodule Welcome do
  use Phoenix.LiveComponent
  import CoinPortfolio.Utils.TransactionUtils

  def render(assigns) do
    ~L"""
    <div class="ui center aligned container mt-3">
      <h1 class="ui center aligned inverted icon header">
        <i class="bitcoin icon"></i>
        <div class="content">Coin Portfolio</div>
      </h1>
      <div class="inline">
        <a href="/users/register" class="ui positive button">Register</a>
        <a href="/users/log_in" class="ui primary button">Login</a>
      </div>
    </div>
    """
  end
end
