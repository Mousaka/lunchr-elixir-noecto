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

  def newUser(user_data) do
    {:ok, bucket} = Lunchr.Registry.lookup(:lunchr_registry, "users")
    already_exist = Lunchr.Bucket.all(bucket) |>
                      Enum.any?(fn u -> u.oauth_id == user_data.oauth_id end)

    case already_exist do
      false ->
        IO.puts "storing user"
        IO.inspect user_data
        user = %{"oauth_id" => user_data.oauth_id, "name" => user_data.name, "username" => user_data.name}
        uuid = UUID.uuid1()
        user_struct = Lunchr.User.changeset_withid(user, uuid)
        IO.inspect(user_struct)
        Lunchr.Bucket.put(bucket, uuid, user_struct)
      true ->
        IO.puts "user already existing"
        {:ok, "existing user"}
    end
  end
end
