defmodule Lunchr.User do
  @enforce_keys [:username, :name, :token]
  defstruct @enforce_keys
end
