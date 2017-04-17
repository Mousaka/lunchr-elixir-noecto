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

  def addReview(review_params) do
    review_struct = Lunchr.Review.changeset_withid(review_params)
    IO.inspect(review_struct)
    {:ok, bucket} = Lunchr.Registry.lookup(:lunchr_registry, "reviews")
    place_user_ids = { showPlace(review_params["place_id"]), showUser(review_params["user_id"])}
    case place_user_ids do
      {place_id, user_id} when not (is_nil(place_id) or is_nil(user_id)) ->
        {:ok, Lunchr.Bucket.put(bucket, {place_id, user_id}, review_struct)}
      {_place_id, nil} ->
        {:error, "User id not found"}
      {nil, _user_id} ->
        {:error, "Place id not found"}
    end
  end

  def showReviews() do
    {:ok, bucket} = Lunchr.Registry.lookup(:lunchr_registry, "reviews")
    Lunchr.Bucket.all(bucket)
  end

  def showReview(id) do
    {:ok, bucket} = Lunchr.Registry.lookup(:lunchr_registry, "reviews")
    Lunchr.Bucket.get(bucket, id)
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

  def showUser(id) do
    {:ok, bucket} = Lunchr.Registry.lookup(:lunchr_registry, "user")
    Lunchr.Bucket.get(bucket, id)
  end

end
