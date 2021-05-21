defmodule CoinPortfolioWeb.PageController do
  use CoinPortfolioWeb, :controller

  def index(conn, _params) do
    if conn.assigns.current_user.email.pepe do
      render(conn, "index.html")
    else
      redirect(conn, to: "/users/register")
    end
  end
end
