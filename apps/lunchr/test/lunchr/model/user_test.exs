defmodule Lunchr.UserTest do
  use ExUnit.Case, async: true
  alias Lunchr.User

  test "create user struct" do
    assert %{username: "krlu", name: "kristian", oauth_id: "1231", id: "uuid-1231"} = %User{username: "krlu", name: "kristian", oauth_id: "1231", id: "uuid-1231"}
  end

end
