defmodule LunchrInterface.ReviewView do
  use LunchrInterface.Web, :view

  def render("index.json", %{reviews: reviews}) do
    %{data: render_many(reviews, LunchrInterface.ReviewView, "review.json")}
  end

  def render("show.json", %{review: review}) do
    %{data: render_one(review, LunchrInterface.ReviewView, "review.json")}
  end

  def render("review.json", %{review: {newid, review}}) do
    review
  end

  def render("review.json", %{review: review}) do
    review
  end
end
