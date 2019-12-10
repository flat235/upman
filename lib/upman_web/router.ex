defmodule UpmanWeb.Router do
  use UpmanWeb, :router

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

  scope "/", UpmanWeb do
    # Use the default browser stack
    pipe_through [:browser]

    resources("/servers", ServerController)
    get "/", PageController, :index
    get "/session/login", SessionController, :new
    get "/session/logout", SessionController, :delete
    post "/session/create", SessionController, :create
    post "/clearance/:name", ClearanceController, :set
  end

  scope "/api", UpmanWeb do
    pipe_through :api
    get "/servers", ApiController, :index
    get "/server/:name", ApiController, :show
    post "/server/:name", ApiController, :update
    get "/clearance/:name", ApiController, :clearance
    get "/result/:server", ResultController, :show
    post "/result/:server", ResultController, :update
  end
end
