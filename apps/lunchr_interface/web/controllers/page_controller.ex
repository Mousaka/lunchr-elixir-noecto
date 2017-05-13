defmodule LunchrInterface.PageController do
  use LunchrInterface.Web, :controller

  # defp mock_auth() do
  #   Keyword.get(config(), :mock_auth, false)
  # end

  def index(conn, _params) do
    conn |> assign(:current_user, get_session(conn, :current_user))
         |> render("index.html")
  end
end
