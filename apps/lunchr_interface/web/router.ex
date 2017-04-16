defmodule LunchrInterface.Router do
  use LunchrInterface.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LunchrInterface do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

scope "/auth", LunchrInterface do
  pipe_through :browser # Use the default browser stack

  get "/:provider", AuthController, :index
  get "/:provider/callback", AuthController, :callback
  delete "/logout", AuthController, :delete
end

  scope "/api", LunchrInterface do
    pipe_through :api
    resources "/users", UserController, except: [:new, :edit]
    resources "/places", PlaceController, except: [:new, :edit]
  end
end
