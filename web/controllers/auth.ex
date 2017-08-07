defmodule CableCarSpotter.Auth do
  import Plug.Conn
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  import Phoenix.Controller
  import CableCarSpotter.Gettext
  alias CableCarSpotter.Router.Helpers

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)

    cond do
      user = conn.assigns[:current_user] ->
        conn
      user = user_id && repo.get(CableCarSpotter.User, user_id) ->
        assign(conn, :current_user, user)
      true ->
        assign(conn, :current_user, nil)
    end
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end

  def login_by_email_and_pass(conn, email, given_pass, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(CableCarSpotter.User, email: email)

    cond do
      user && checkpw(given_pass, user.password_hash) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end

  def authenticate_user(conn, _opts) do
    if is_logged_in?(conn) do
      conn
    else
      conn
      |> put_flash(:error, gettext("You must be logged in to access that page"))
      |> redirect(to: Helpers.session_path(conn, :new, conn.assigns.locale))
      |> halt()
    end
  end

  def authenticate_admin(conn, _opts) do
    if is_admin?(conn) do
      conn
    else
      conn
      |> put_flash(:error, gettext("You are not allowed to access that page"))
      |> redirect(to: Helpers.page_path(conn, :index, conn.assigns.locale))
      |> halt()
    end
  end

  defp is_logged_in?(conn) do
    conn.assigns.current_user
  end

  defp is_admin?(conn) do
    user = is_logged_in?(conn)
    user && user.role == "admin"
  end
end
