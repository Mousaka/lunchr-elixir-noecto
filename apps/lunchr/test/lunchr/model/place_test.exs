defmodule Lunchr.PlaceTest do
  use ExUnit.Case, async: true
  alias Lunchr.Place

  test "create place struct" do
    assert %{name: "Knut", cuisine: "husman", id: 1231}  = %Place{name: "Knut", cuisine: "husman", id: 1231}
  end

end
