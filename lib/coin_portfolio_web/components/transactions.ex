defmodule TransactionsComponent do
  use Phoenix.LiveComponent
  alias CoinPortfolio.Transactions
  import CoinPortfolioWeb.IndexLive
  import CoinPortfolio.Utils.TransactionUtils

  @impl
  def render(assigns) do
    ~L"""
    <div class="ui horizontal scrollable p-0 mb-1 segment">
      <table class="ui selectable unstackable table">
        <thead>
          <tr>
            <th>Token</th>
            <th>Type</th>
            <th>Amount</th>
            <th>Date</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <%=for transaction <- @transactions do %>
          <tr>
            <td>
              <img src="<%= "https://s2.coinmarketcap.com/static/img/coins/128x128/#{@rates["#{String.upcase(transaction.token)}/#{@current_user.main_currency}"].id}.png" %>" class="ui mini circular inline image" />
              &nbsp;
              <span class="capitalize"><%=@token_names[String.upcase(transaction.token)] %></span>
            </td>
            <td>
              <%=if transaction.type == "buy" do %>
                <div class="ui green label">buy</div>
              <%else %>
                <div class="ui red label">sell</div>
              <%end %>
            </td>
            <td class="">
              <div class="ui list">
                <div class="item">
                  <%=if transaction.type == "buy" do %>
                    <h5 class="ui green header">
                      +<%= transaction.token_amount %> <%= String.upcase(transaction.token) %>
                    </h5>
                  <%else %>
                    <h5 class="ui red header">
                      -<%= transaction.token_amount %> <%= String.upcase(transaction.token) %>
                    </h5>
                  <%end %>
                </div>
                <div class="item"><%= to_money(transaction.currency_amount, @current_user, true) %> <%= String.upcase(transaction.main_currency) %></div>
              </div>
            </td>
            <td>
              <div class=""><%= pretty_transaction_date(transaction.date) %></div>
            </td>
            <td>
              <button class="ui basic icon button" phx-click="delete" phx-value-transactionId="<%=transaction.id %>">
                <i class="trash icon"></i>
              </button>
            </td>
          </tr>
          <%end %>
        </tbody>
      </table>
    </div>
    """
  end

end
