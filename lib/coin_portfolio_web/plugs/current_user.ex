defmodule CoinPortfolioWeb.CurrentUser do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _params) do
    put_session(conn, "current_user", conn.assigns.current_user)
  end


end
