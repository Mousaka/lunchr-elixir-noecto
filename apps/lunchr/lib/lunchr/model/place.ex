defmodule Lunchr.Place do
  @enforce_keys [:name, :cuisine, :id]
  defstruct @enforce_keys

  def changeset(place_params) do
    atomified_params = for {key, val} <- place_params, into: %{}, do: {String.to_atom(key), val}
    struct!(Lunchr.Place, atomified_params)
  end

  def changeset_withid(place_params, id) do
    place_params
      |> Map.put_new("id", id)
      |> changeset
  end
end
