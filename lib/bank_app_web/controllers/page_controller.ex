defmodule BankAppWeb.PageController do
  use BankAppWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", homepage_text: "Greetings from the best bank in the world!")
  end
end
