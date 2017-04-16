defmodule Lunchr.Bucket do

  def start_link do
    Agent.start_link(fn -> %{} end)
  end

  def get(bucket, key) do
    Agent.get(bucket, fn map -> Map.get(map, key) end)
  end

  def put(bucket, key, value) do
    {Agent.update(bucket, fn map -> Map.put(map, key, value) end), value}
  end

  def all(bucket) do
    Agent.get(bucket, fn map -> Map.values(map) end)
  end

end
