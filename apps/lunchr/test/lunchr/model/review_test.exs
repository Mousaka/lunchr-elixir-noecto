defmodule Lunchr.ReviewTest do
  use ExUnit.Case, async: true

  test "create place struct" do
    user = Lunchr.Review.changeset_withid(%{"user_id" => "user123", "place_id" => "place123", "rating" => 4.5, "comment" => "nah"})
    assert %Lunchr.Review{id: {"place123", "user123"}, user_id: "user123", place_id: "place123", rating: 4.5, comment: "nah"} == user
  end

end
