defmodule Lunchr.User do
  @enforce_keys [:username, :name, :oauth_id, :id]
  defstruct @enforce_keys

  def changeset(user_params) do
    atomified_params = for {key, val} <- user_params, into: %{}, do: {String.to_atom(key), val}
    struct!(Lunchr.User, atomified_params)
  end


  def changeset_withid(user_params, id) do
    user_params
      |> Map.put_new("id", id)
      |> changeset
  end
end
