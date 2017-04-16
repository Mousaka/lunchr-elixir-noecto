defmodule LunchrInterface.PlaceController do
  use LunchrInterface.Web, :controller

  def index(conn, _params) do
    {:ok, bucket} = Lunchr.Registry.lookup(:lunchr_registry, "places")
    places = Lunchr.Bucket.all(bucket)
    render(conn, "index.json", places: places)
  end

  def show(conn, %{"id" => id }) do
    {:ok, bucket} = Lunchr.Registry.lookup(:lunchr_registry, "places")
    item = Lunchr.Bucket.get(bucket, id)
    json conn, item
  end

  def create(conn, %{"place" => place_params}) do
    {:ok, bucket} = Lunchr.Registry.lookup(:lunchr_registry, "places")

    case Lunchr.Bucket.put(bucket, UUID.uuid1(), place_params) do
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
