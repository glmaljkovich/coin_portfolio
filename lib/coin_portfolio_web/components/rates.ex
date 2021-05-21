defmodule Rates do
  use Phoenix.LiveComponent
  import CoinPortfolio.Utils.TransactionUtils

  def render(assigns) do
    ~L"""
    <div class="ui segment">
      <div class="flex">
        <div class="ui large horizontal scrollable list">
        <%=for {token, rate} <- @rates do%>
            <div class="item">
              <i class="large circular <%=@token_names[token] %> icon"></i>
              <div class="content w-auto">
                <div class="ui sub header"><%= token %></div>
                <p><%= to_money(rate, @current_user, true) %> <%= @current_user.main_currency%></p>
              </div>
            </div>
        <%end %>
        </div>
      </div>
    </div>
    """
  end
end
