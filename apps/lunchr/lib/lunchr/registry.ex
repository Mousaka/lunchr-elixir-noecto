defmodule Lunchr.Registry do
  use GenServer
  alias Lunchr.User
  # def start_link do
  def start_link(name) do
    # GenServer.start_link(__MODULE__, :ok, [])
    GenServer.start_link(__MODULE__, :ok, name: name)
  end

  def reset(server) do
    case GenServer.whereis(server) do
      nil ->
        start_link(server)
      _ ->
        GenServer.stop(server)
        start_link(server)
      end
  end

  def lookup(server, name) do
    GenServer.call(server, {:lookup, name})
  end

  def create(server, name) do
    GenServer.cast(server, {:create, name})
  end

  def init(:ok) do
    {:ok, %{"users" => initUsers(), "places" => initPlaces(), "reviews" => initReviews()}}
  end

  defp initUsers() do
    {:ok, user_bucket} = Lunchr.Bucket.start_link
    goduser = %User{username: "goduser", name: "Kristian", oauth_id: "123", id: "uuid-123"}
    Lunchr.Bucket.put(user_bucket, "goduser", goduser)
    user_bucket
  end

  defp initPlaces() do
    {:ok, places_bucket} = Lunchr.Bucket.start_link
    places_bucket
  end

  defp initReviews() do
    {:ok, reviews_bucket} = Lunchr.Bucket.start_link
    reviews_bucket
  end

  def handle_call({:lookup, name}, _from, names) do
    {:reply, Map.fetch(names, name), names}
  end

  def handle_cast({:create, name}, names) do
    if Map.has_key?(names, name) do
      {:noreply, names}
    else
      {:ok, bucket} = Lunchr.Bucket.start_link
      {:noreply, Map.put(names, name, bucket)}
    end
  end

end
