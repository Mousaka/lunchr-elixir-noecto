defmodule LunchrInterface.PageController do
  use LunchrInterface.Web, :controller

  defp mock_auth() do
    conf = Application.get_env(:lunchr_interface, LunchrInterface.PageController)
    Keyword.get(conf, :mock_auth, false)
  end

  def index(conn, _params) do
    conn |> assign(:current_user, help(conn))
         |> render("index.html")
  end

  defp help(conn) do
    if mock_auth() do
      IO.puts "Mock auth!"
      %{name: "Mockz0r", avatar: "", oauth_id: "mockid123"}
    else
      IO.puts "Real auth!"
      get_session(conn, :current_user)
    end
  end
end
