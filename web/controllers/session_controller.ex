defmodule CableCarSpotter.SessionController do
  use CableCarSpotter.Web, :controller

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"email" => email, "password" => pass}}) do
    case CableCarSpotter.Auth.login_by_email_and_pass(conn, email, pass, repo: Repo) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, gettext("Welcome back!"))
        |> redirect(to: page_path(conn, :index, conn.assigns.locale))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, gettext("Invalid email/password combination"))
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> CableCarSpotter.Auth.logout()
    |> redirect(to: page_path(conn, :index, conn.assigns.locale))
  end
end
