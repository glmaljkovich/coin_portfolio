defmodule Rates do
  use Phoenix.LiveComponent
  import CoinPortfolio.Utils.TransactionUtils

  def render(assigns) do
    ~L"""
    <div class="ui segment">
      <div class="flex">
        <div class="ui large horizontal scrollable list">
        <%=for {token, rate} <- @rates do%>
          <%= if currency_from_rate(token) == @current_user.main_currency do %>
            <div class="item">
              <img src="<%= "https://s2.coinmarketcap.com/static/img/coins/128x128/#{rate.id}.png" %>" class="ui mini circular image" />
              <div class="content w-auto">
                <div class="ui sub header"><%= Enum.at(String.split(token, "/"), 0) %></div>
                <p><%= to_money(rate.rate, @current_user, true) %> <%= @current_user.main_currency%></p>
              </div>
            </div>
          <%end %>
        <%end %>
        </div>
      </div>
    </div>
    """
  end
end
