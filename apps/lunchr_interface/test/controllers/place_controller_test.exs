defmodule Lunchr.PlaceControllerTest do
  use LunchrInterface.ConnCase, async: true

  alias Lunchr.Place
  @valid_attrs %Place{name: "Knut", cuisine: "husman", id: 1231}
  @valid_attrs_json %{"name" => "Knut", "cuisine" => "husman", "id" => 1231}

  @invalid_attrs %{}

  setup context do
    {:ok, registry} = Lunchr.Registry.start_link(context.test)
    {:ok, registry: registry}
  end

  setup %{conn: conn} do
    Lunchr.Registry.reset(:lunchr_registry)
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, place_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "add one and lists all entries on index", %{conn: conn} do
    conn = post conn, place_path(conn, :create), place: @valid_attrs
    conn = get conn, place_path(conn, :index)
    assert json_response(conn, 200)["data"] == [@valid_attrs_json]
  end

end