defmodule Lunchr.UserTest do
  use ExUnit.Case, async: true
  alias Lunchr.User

  test "create user struct" do
    assert %{username: "krlu", name: "kristian", token: 1231}  = %User{username: "krlu", name: "kristian", token: 1231}
  end

end
