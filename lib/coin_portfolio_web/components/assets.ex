defmodule Assets do
  use Phoenix.LiveComponent
  import CoinPortfolio.Utils.TransactionUtils

  def render(assigns) do
    ~L"""
    <div class="ui three stackable cards mt-1">
    <%=for asset <- @assets do %>
      <div class="ui card">
        <div class="content">
          <div class="ui grid">
            <div class="eight wide column">
              <img src="<%= "https://s2.coinmarketcap.com/static/img/coins/128x128/#{@rates["#{String.upcase(asset.token)}/#{@current_user.main_currency}"].id}.png" %>" class="ui mini circular left floated image" />
              <div class="ui header no-margin">
                <span class="capitalize"><%=@token_names[String.upcase(asset.token)] %><span>
              </div>
              <div class="meta small">
                <%= String.upcase(asset.token) %>
              </div>
            </div>
            <div class="eight wide column">
              <div class="ui right aligned list">
                <div class="item">
                  <h5 class="ui header">
                    <%= to_precision(asset.total, 8) %> <%= String.upcase(asset.token) %>
                  </h5>
                </div>
                <div class="item"><%= to_money(token_to_main_currency(asset, @rates, @current_user), @current_user, true) %> <%= String.upcase(@current_user.main_currency) %></div>
              </div>
            </div>
          </div>
        </div>
        <div class="extra content">
          <span>
            <%=if rates_get(@rates, asset.token, @current_user, :percent_change_24h) < 0.00 do %>
            <i class="small red caret down fitted icon"></i>
            <span class="red text"><%= to_precision(-1 * rates_get(@rates, asset.token, @current_user, :percent_change_24h), 2) %>%</span>
            <%else %>
            <i class="small green caret up fitted icon"></i>
            <span class="green text"><%= to_precision(rates_get(@rates, asset.token, @current_user, :percent_change_24h), 2) %>%</span>
            <%end %>
            <span>/ 24hs</span>
          </span>
          <span class="right floated">
            <%=if rates_get(@rates, asset.token, @current_user, :percent_change_7d) < 0.00 do %>
            <i class="small red caret down fitted icon"></i>
            <span class="red text"><%= to_precision(-1 * rates_get(@rates, asset.token, @current_user, :percent_change_7d), 2) %>%</span>
            <%else %>
            <i class="small green caret up fitted icon"></i>
            <span class="green text"><%= to_precision(rates_get(@rates, asset.token, @current_user, :percent_change_7d), 2) %>%</span>
            <%end %>
            <span>/ 7d</span>
          </span>
        </div>
      </div>
    <%end %>
    </div>
    """
  end
end
