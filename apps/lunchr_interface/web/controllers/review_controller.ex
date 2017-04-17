defmodule LunchrInterface.ReviewController do
  use LunchrInterface.Web, :controller

  def index(conn, _params) do
    render(conn, "index.json", reviews: Lunchr.showReviews())
  end

  def show(conn, %{"id" => id }) do
    json conn, Lunchr.showReview(id)
  end

  def create(conn, %{"review" => review_params}) do
    user_id = conn |> get_session(:current_user) |> (fn u -> u.id end).()
    review_with_user_id = Map.put(review_params, "user_id", user_id)
    case Lunchr.addReview(review_with_user_id) do
      {:ok, review} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", review_path(conn, :show, review))
        |> render("show.json", review: review)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(LunchrInterface.ChangesetView, "error.json", changeset: changeset)
      end
  end

end
