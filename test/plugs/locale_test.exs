defmodule CableCarSpotter.Plugs.LocaleTest do
  use CableCarSpotterWeb.ConnCase

  test "no locale params is passed in, but browser accepts 'en', user is redirected to 'en' version of the path" do
    conn = build_conn(:get, "/u/new", %{})
           |> put_req_header("accept-language", "en-US,en;q=0.8")
           |> CableCarSpotter.Plug.Locale.call("en")

    assert redirected_to(conn) == "/en/u/new"
  end

  test "no locale params is passed in, but browser accepts 'es' (which is supported), user is redirected to 'es' version of the path" do
    conn = build_conn(:get, "/u/new", %{})
           |> put_req_header("accept-language", "es-ES,es;q=0.8")
           |> CableCarSpotter.Plug.Locale.call("en")

    assert redirected_to(conn) == "/es/u/new"
  end

  test "no locale params is passed in, but browser accepts 'es' (which is supported), user is redirected to 'es' version of the path (with a query string)" do
    conn = build_conn(:get, "/u/new?foo=bar&baz=bop", %{})
           |> put_req_header("accept-language", "es-ES,es;q=0.8")
           |> CableCarSpotter.Plug.Locale.call("en")

    assert redirected_to(conn) == "/es/u/new?foo=bar&baz=bop"
  end

  test "no locale params is passed in, but browser accepts 'en', user is redirected to 'en' homepage" do
    conn = build_conn(:get, "/", %{})
           |> put_req_header("accept-language", "en-US,en;q=0.8")
           |> CableCarSpotter.Plug.Locale.call("en")

    assert redirected_to(conn) == "/en/"
  end

  test "no locale params is passed in and the browser accepts 'ko', user is redirected to 'en' homepage" do
    conn = build_conn(:get, "/", %{})
           |> put_req_header("accept-language", "ko-KR,ko;q=0.8")
           |> CableCarSpotter.Plug.Locale.call("en")

    assert redirected_to(conn) == "/en/"
  end

  test "a valid, but not whitelisted BCP47 IETF language tag is passed in, user is redirected to default locale path" do
    conn = build_conn(:get, "/ko", %{ "locale" => "ko" })
           |> CableCarSpotter.Plug.Locale.call("en")

    assert redirected_to(conn) == "/en"
  end

  test "a valid and whitelisted BCP47 IETF language tag is passed in, it is added to the session" do
    conn = build_conn()
           |> Map.put(:params, %{ "locale" => "es" })
           |> CableCarSpotter.Plug.Locale.call("en")

    assert conn.assigns.locale == "es"
  end

  test "a valid and whitelisted BCP47 IETF language tag is passed in, the user is not redirected" do
    conn = build_conn()
           |> Map.put(:params, %{ "locale" => "es" })
           |> CableCarSpotter.Plug.Locale.call("en")

    assert not_redirected?(conn)
  end

  defp not_redirected?(conn) do
    conn.status != 302
  end
end
