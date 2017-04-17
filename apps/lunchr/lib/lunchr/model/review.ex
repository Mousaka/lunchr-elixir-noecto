defmodule Lunchr.Review do
  @enforce_keys [:id, :place_id, :user_id, :comment, :rating]
  defstruct @enforce_keys

  def changeset(review_params) do
    atomified_params = for {key, val} <- review_params, into: %{}, do: {String.to_atom(key), val}
    struct!(Lunchr.Review, atomified_params)
  end


  def changeset_withid(review_params) do
    review_params
      |> Map.put_new("id", {review_params["place_id"], review_params["user_id"]})
      |> changeset
  end
end
