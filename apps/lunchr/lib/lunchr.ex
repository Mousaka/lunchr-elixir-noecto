defmodule Lunchr do
  import Lunchr.Place
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
    place_struct = changeset_withid(place_params, uuid)
    IO.inspect(place_struct)
    Lunchr.Bucket.put(bucket, uuid, place_struct)
  end
end
