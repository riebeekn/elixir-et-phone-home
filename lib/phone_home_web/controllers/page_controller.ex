defmodule PhoneHomeWeb.PageController do
  use PhoneHomeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
