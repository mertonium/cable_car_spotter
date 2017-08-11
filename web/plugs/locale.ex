defmodule CableCarSpotter.Plug.Locale do
  import Plug.Conn

  def init(default), do: default

  def call(conn, default) do
    if supported_locale_is_in_url?(conn) do
      conn |> assign_locale!(conn.params["locale"])
    else
      conn |> redirect_to_localized_path(default)
    end
  end

  defp redirect_to_localized_path(conn, default_locale) do
    derived_locale = extract_locale(conn) || default_locale

    path = if locale_in_url?(conn) do
      localized_path(conn.request_path, derived_locale, conn.params["locale"])
    else
      localized_path(conn.request_path, derived_locale)
    end

    conn |> redirect_to(path)
  end

  defp locale_in_url?(conn) do
    Map.has_key?(conn.params, "locale") && is_ietf_tag?(conn.params["locale"])
  end

  defp is_ietf_tag?(l) do
    BCP47.valid?(l, ietf_only: true)
  end

  defp supported_locale_is_in_url?(conn) do
    locale_in_url?(conn) && supported_locale?(conn.params["locale"])
  end

  defp assign_locale!(conn, value) do
    Gettext.put_locale(CableCarSpotter.Gettext, value)
    conn |> assign(:locale, value)
  end

  defp extract_locale(conn) do
    [conn.params["locale"] | extract_accept_language(conn)]
    |> List.delete(nil)
    |> Enum.filter(&supported_locale?/1)
    |> List.first()
  end

  defp extract_accept_language(conn) do
    case conn |> get_req_header("accept-language") do
      [value|_] ->
        value
        |> String.split(",")
        |> Enum.map(&parse_language_options/1)
        |> Enum.sort(&(&1.quality > &2.quality))
        |> Enum.map(&(&1.tag))
      _ ->
        []
    end
  end

  defp parse_language_options(string) do
    captures = ~r/^(?<tag>[\w\-]+)(?:;q=(?<quality>[\d\.]+))?$/i
      |> Regex.named_captures(string)

    quality = case Float.parse(captures["quality"] || "1.0") do
      {val, _} -> val
      _ -> 1.0
    end

    %{tag: captures["tag"], quality: quality}
  end

  defp localized_path(request_path, locale, original) do
    # Swap the given locale with a supported one
    ~r/(\/)#{original}(\/(?:.+)?|\?(?:.+)?|$)/
    |> Regex.replace(request_path, "\\1#{locale}\\2")
  end

  defp localized_path(request_path, locale) do
    # Return a localized version of the url
    "/#{locale}#{request_path}"
  end

  defp redirect_to(conn, path) do
    path = case conn.query_string do
      "" -> path
      _ -> path <> "?#{conn.query_string}"
    end

    conn
      |> Phoenix.Controller.redirect(to: path)
      |> halt()
  end

  defp supported_locale?(l) do
    l in CableCarSpotter.Gettext.supported_locales
  end
end
