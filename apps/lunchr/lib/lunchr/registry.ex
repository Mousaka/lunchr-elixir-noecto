defmodule Lunchr.Registry do
  use GenServer

  # def start_link do
  def start_link(name) do
    # GenServer.start_link(__MODULE__, :ok, [])
    IO.puts(name)
    GenServer.start_link(__MODULE__, :ok, name: name)
  end

  def lookup(server, name) do
    GenServer.call(server, {:lookup, name})
  end

  def create(server, name) do
    GenServer.cast(server, {:create, name})
  end

  def init(:ok) do
    {:ok, user_bucket} = Lunchr.Bucket.start_link
    map = Map.put(%{}, "users", user_bucket)
    {:ok, place_bucket} = Lunchr.Bucket.start_link
    Lunchr.Bucket.put(user_bucket, "Krlu", 4)
    data = Map.put(map, "places", place_bucket)
    {:ok, data}
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
