defmodule LunchrInterface.PlaceView do
  use LunchrInterface.Web, :view

  def render("index.json", %{places: places}) do
    %{data: render_many(places, LunchrInterface.PlaceView, "place.json")}
  end

  def render("show.json", %{place: place}) do
    %{data: render_one(place, LunchrInterface.PlaceView, "place.json")}
  end

  def render("place.json", %{place: {newid, place}}) do
    %{name: place.name,
      cuisine: place.cuisine,
      id: place.id}
  end

  def render("place.json", %{place: place}) do
    %{name: place.name,
      cuisine: place.cuisine,
      id: place.id}
  end
end
