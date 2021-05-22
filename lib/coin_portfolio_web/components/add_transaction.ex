defmodule AddTransaction do
  use Phoenix.LiveComponent
  import CoinPortfolioWeb.IndexLive
  alias Phoenix.HTML.Form
  alias CoinPortfolio.Transactions

  def render(assigns) do
    ~L"""
    <div id="addTransaction" class="ui blue segment">
      <form action="#" phx-submit="add">
        <div class="ui equal width form">
          <div class="fields">
            <div class="field">
              <label>Type</label>
              <div class="ui compact selection dropdown button">
                <%= Form.text_input :transaction, :type, type: "hidden" %>
                <div class="default text">buy</div>
                <i class="dropdown icon"></i>
                <div class="menu">
                  <div class="item">buy</div>
                  <div class="item">sell</div>
                </div>
              </div>
            </div>
            <div class="field">
              <label>Date</label>
              <div class="ui input">
                <%= Form.date_input :transaction, :date %>
              </div>
            </div>
          </div>
          <div class="fields">
            <div class="field">
              <label>Amount</label>
              <div class="ui left icon input">
                <i class="dollar sign icon"></i>
                <%= Form.text_input :transaction, :currency_amount, placeholder: "0.00" %>
              </div>
            </div>
              <div class="field">
                <label>Currency</label>
                <div class="ui compact selection dropdown button">
                  <%= Form.text_input :transaction, :main_currency, type: "hidden" %>
                  <div class="default text"><%= Enum.at(@accepted_currencies, 0) %></div>
                  <i class="dropdown icon"></i>
                  <div class="menu">
                    <%=for currency <- @accepted_currencies do %>
                      <div class="item"><%= currency %></div>
                    <%end %>
                  </div>
                </div>
              </div>
            <div class="field">
              <label>Tokens</label>
              <div class="ui left icon input">
                <i class="dollar sign icon"></i>
                <%= Form.text_input :transaction, :token_amount, placeholder: "0.00" %>
              </div>
            </div>
            <div class="field">
              <label>Cryptocurrency</label>
              <div class="ui compact selection dropdown button">
                <%= Form.text_input :transaction, :token, type: "hidden" %>
                <div class="default text"><%= Enum.at(@accepted_tokens, 0) %></div>
                <i class="dropdown icon"></i>
                <div class="menu">
                  <%=for token <- @accepted_tokens do %>
                    <div class="item"><%= token %></div>
                  <%end %>
                </div>
              </div>
            </div>
        </div>
        <%= Form.submit "Add", phx_disable_with: "Adding...", class: "ui green button" %>
        <script>
        $('#addTransaction').ready(() => {
          $('.ui.dropdown').dropdown();
          $('.ui.checkbox').checkbox();
        });
        </script>
      </form>
    </div>
    """
  end

  def handle_event("add", %{"transaction" => transaction}, socket) do
    current_user = socket.assigns.current_user
    Transactions.create_transaction(transaction, current_user)

    {:noreply, fetch_transactions_and_rates(socket)}
  end
end
