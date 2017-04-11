defmodule LunchrInterface.PageController do
  use LunchrInterface.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
