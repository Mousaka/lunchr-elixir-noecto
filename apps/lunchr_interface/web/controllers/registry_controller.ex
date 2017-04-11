defmodule LunchrInterface.RegistryController do
 use LunchrInterface.Web, :controller

 def show(conn, %{"name" => name}) do
  item = Lunchr.Registry.lookup(:lunchr_registry, name)
  render(conn, "show.html", item: item)
 end

 def create(conn, %{"name" => name}) do
  item = Lunchr.Registry.create(:lunchr_registry, name)
  render(conn, "show.html", item: item)
 end
end
