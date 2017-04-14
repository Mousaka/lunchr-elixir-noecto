defmodule Lunchr.Place do
  @enforce_keys [:name, :cuisine, :id]
  defstruct @enforce_keys
end
