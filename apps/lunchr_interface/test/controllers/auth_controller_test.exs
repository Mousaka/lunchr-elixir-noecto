defmodule Lunchr.AuthControllerTest do
  use ExUnit.Case, async: true


  setup do
    Lunchr.Registry.reset(:lunchr_registry)
    :ok
  end



  test "store new user" do
    user = %{"name" => "pelle", "oauth_id" => "111"}
    user_withid = LunchrInterface.AuthController.store_user(user)
    assert 0 != String.length(user_withid["id"])
  end



  test "existing user gives user with uuid" do
    user = %{"name" => "pelle", "oauth_id" => "111"}
    LunchrInterface.AuthController.store_user(user)
    user_withid = LunchrInterface.AuthController.store_user(user)
    assert 0 != String.length(user_withid["id"])
  end

end
