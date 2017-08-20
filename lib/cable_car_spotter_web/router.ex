defmodule CableCarSpotterWeb.Router do
  use CableCarSpotter.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug CableCarSpotterWeb.Auth, repo: CableCarSpotter.Repo
    plug CableCarSpotter.Plug.Locale, "en"
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CableCarSpotterWeb do
    pipe_through :browser
    get "/", PageControllerWeb, :dummy
  end

  scope "/:locale", CableCarSpotterWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/c", CableCarController, only: [:index, :show]
    resources "/u", UserController, only: [:new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    get "/punchcard", SightingController, :punchcard
    resources "/s", SightingController
  end

  scope "/admin", CableCarSpotterWeb do
    pipe_through [:browser, :authenticate_admin]
    resources "/cable_cars", CableCarController
    resources "/users", UserController
  end

  # Other scopes may use custom stacks.
  # scope "/api", CableCarSpotter do
  #   pipe_through :api
  # end
end
