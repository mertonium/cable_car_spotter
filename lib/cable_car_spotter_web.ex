defmodule CableCarSpotter.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use CableCarSpotter.Web, :controller
      use CableCarSpotter.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model do
    quote do
      use Ecto.Schema

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
    end
  end

  def controller do
    quote do
      use Phoenix.Controller, namespace: CableCarSpotterWeb

      alias CableCarSpotter.Repo
      import Ecto
      import Ecto.Query

      import CableCarSpotterWeb.Router.Helpers
      import CableCarSpotterWeb.Gettext
      import CableCarSpotterWeb.Auth, only: [authenticate_user: 2]
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "lib/cable_car_spotter_web/templates",
                        namespace: CableCarSpotterWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import CableCarSpotterWeb.Router.Helpers
      import CableCarSpotterWeb.ErrorHelpers
      import CableCarSpotterWeb.Gettext
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import CableCarSpotterWeb.Auth, only: [authenticate_user: 2, authenticate_admin: 2]
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias CableCarSpotter.Repo
      import Ecto
      import Ecto.Query
      import CableCarSpotterWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
