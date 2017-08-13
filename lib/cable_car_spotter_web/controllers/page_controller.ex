defmodule CableCarSpotterWeb.PageController do
  use CableCarSpotter.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
