defmodule Lunchr.RegistryTest do
  use ExUnit.Case, async: true
  alias  Lunchr.User
  setup context do
    {:ok, registry} = Lunchr.Registry.start_link(context.test)
    {:ok, registry: registry}
  end

  test "initial buckets", %{registry: registry} do
    assert {:ok, user_bucket} = Lunchr.Registry.lookup(registry, "users")
    Lunchr.Bucket.put(user_bucket, "jeja", 1)
    assert Lunchr.Bucket.get(user_bucket, "jeja") == 1

    assert {:ok, place_bucket} = Lunchr.Registry.lookup(registry, "places")
    Lunchr.Bucket.put(place_bucket, "Jappi", 3)
    assert Lunchr.Bucket.get(place_bucket, "Jappi") == 3
  end

  test "create places and put place", %{registry: registry} do

    assert {:ok, bucket} = Lunchr.Registry.lookup(registry, "places")

    Lunchr.Bucket.put(bucket, "Jappi", %{"name" => "Jappi", "address" => "Testv. 1"})
    assert Lunchr.Bucket.get(bucket, "Jappi") == %{"name" => "Jappi", "address" => "Testv. 1"}
    data = Lunchr.Bucket.get(bucket, "Jappi")
    assert Map.get(data, "address") == "Testv. 1"
  end

  test "no bananas", %{registry: registry} do
    assert Lunchr.Registry.lookup(registry, "bananas") == :error
  end

  test "find goduser", %{registry: registry} do
    assert {:ok, user_bucket} = Lunchr.Registry.lookup(registry, "users")
    assert Lunchr.Bucket.get(user_bucket, "goduser") == %User{username: "goduser", name: "Kristian", oauth_id: "123", id: "uuid-123"}
  end

  test "get all users", %{registry: registry} do
    {:ok, user_bucket} = Lunchr.Registry.lookup(registry, "users")
    allUsers = Lunchr.Bucket.all(user_bucket)
    assert allUsers == [%User{username: "goduser", name: "Kristian", oauth_id: "123", id: "uuid-123"}]
  end
end
