defmodule CableCarSpotter.Router do
  use CableCarSpotter.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug CableCarSpotter.Auth, repo: CableCarSpotter.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CableCarSpotter do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/c", CableCarController, only: [:index, :show]
    resources "/u", UserController, only: [:index, :show, :new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/s", SightingController
  end

  scope "/admin", CableCarSpotter do
    pipe_through [:browser, :authenticate_admin]
    resources "/cable_cars", CableCarController
  end

  # Other scopes may use custom stacks.
  # scope "/api", CableCarSpotter do
  #   pipe_through :api
  # end
end
