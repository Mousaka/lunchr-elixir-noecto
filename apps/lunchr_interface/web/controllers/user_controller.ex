defmodule LunchrInterface.UserController do
  use LunchrInterface.Web, :controller

  def show(conn, %{}) do
    {:ok, bucket} = Lunchr.Registry.lookup(:lunchr_registry, "users")
    item = Lunchr.Bucket.get(bucket, "goduser")
    json conn, item
  end

end
