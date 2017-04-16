defmodule LunchrInterface.PlaceController do
  use LunchrInterface.Web, :controller

  def index(conn, _params) do
    render(conn, "index.json", places: Lunchr.showPlaces())
  end

  def show(conn, %{"id" => id }) do
    json conn, Lunchr.showPlace(id)
  end

  def create(conn, %{"place" => place_params}) do
    case Lunchr.addPlace(place_params) do
      {:ok, place} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", place_path(conn, :show, place))
        |> render("show.json", place: place)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(LunchrInterface.ChangesetView, "error.json", changeset: changeset)
      end
  end

end
