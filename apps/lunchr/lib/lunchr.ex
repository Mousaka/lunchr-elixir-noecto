defmodule Lunchr do
  @moduledoc """
  Documentation for Lunchr.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Lunchr.hello
      :world

  """
  def hello do
    :world
  end

  def showPlaces() do
    {:ok, bucket} = Lunchr.Registry.lookup(:lunchr_registry, "places")
    Lunchr.Bucket.all(bucket)
  end

  def showPlace(id) do
    {:ok, bucket} = Lunchr.Registry.lookup(:lunchr_registry, "places")
    Lunchr.Bucket.get(bucket, id)
  end

  def addPlace(place_params) do
    {:ok, bucket} = Lunchr.Registry.lookup(:lunchr_registry, "places")
    uuid = UUID.uuid1()
    place_struct = Lunchr.Place.changeset_withid(place_params, uuid)
    IO.inspect(place_struct)
    Lunchr.Bucket.put(bucket, uuid, place_struct)
  end

  def addReview(user,place,review) do
    {:ok, bucket} = Lunchr.Registry.lookup(:lunchr_registry, "reviews")

  end

  def newUser(user_data) do
    {:ok, bucket} = Lunchr.Registry.lookup(:lunchr_registry, "users")
    existing_user = Lunchr.Bucket.all(bucket) |>
                      Enum.find(fn u -> u.oauth_id == user_data["oauth_id"] end)

    case existing_user do
      nil ->
        IO.puts "storing user"
        user = %{"oauth_id" => user_data["oauth_id"], "name" => user_data["name"], "username" => user_data["name"]}
        uuid = UUID.uuid1()
        user_struct = Lunchr.User.changeset_withid(user, uuid)
        {:ok, _} = Lunchr.Bucket.put(bucket, uuid, user_struct)
        {:ok, Map.put(user_data, "id", uuid)}
      usr ->
        IO.puts "user already existing"
        {:ok, Map.put(user_data, "id", usr.id)}
    end
  end
end
