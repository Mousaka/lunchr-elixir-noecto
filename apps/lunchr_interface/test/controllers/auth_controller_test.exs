defmodule Lunchr.AuthControllerTest do
  use ExUnit.Case, async: true


  setup do
    Lunchr.Registry.reset(:lunchr_registry)
    :ok
  end



  test "store new user" do
    user = %{"name" => "pelle", "oauth_id" => "111"}
    {:ok, user_withid} = LunchrInterface.AuthController.store_user(user)
    assert 0 != String.length(user_withid["id"])
  end



  test "existing user gives user with uuid" do
    user = %{"name" => "pelle", "oauth_id" => "111"}
    {:ok, _} = LunchrInterface.AuthController.store_user(user)
    {:ok, user_withid} = LunchrInterface.AuthController.store_user(user)
    assert 0 != String.length(user_withid["id"])
  end

end
