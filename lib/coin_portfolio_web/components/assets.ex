defmodule Assets do
  use Phoenix.LiveComponent
  import CoinPortfolio.Utils.TransactionUtils

  def render(assigns) do
    ~L"""
    <div class="ui p-0 segment mb-1">
      <table class="ui selectable unstackable table">
        <thead>
          <tr>
            <th>Token</th>
            <th>Holdings</th>
            <th>Price</th>
          </tr>
        </thead>
        <tbody>
          <%=for asset <- @assets do %>
          <tr>
            <td>
              <i class="large circular <%=@token_names[String.upcase(asset.token)] %> icon"></i>
              <span class="capitalize"><%=@token_names[String.upcase(asset.token)] %><span>
            </td>
            <td>
              <div class="ui list">
                <div class="item">
                  <h5 class="ui header">
                    <%= to_precision(asset.total, 8) %> <%= String.upcase(asset.token) %>
                  </h5>
                </div>
                <div class="item"><%= to_money(token_to_main_currency(asset, @rates, @current_user), @current_user, true) %> <%= String.upcase(@current_user.main_currency) %></div>
              </div>
            </td>
            <td>
              $<%= to_money(@rates["#{String.upcase(asset.token)}/#{@current_user.main_currency}"], @current_user) %> <%= String.upcase(@current_user.main_currency) %>
            </td>
          </tr>
          <%end %>
        </tbody>
      </table>
    </div>
    """
  end
end
