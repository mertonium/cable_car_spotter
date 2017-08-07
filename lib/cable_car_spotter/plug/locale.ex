defmodule CableCarSpotter.Plug.Locale do
  import Plug.Conn

  def init(default), do: default

  def call(conn, default) do
    locale = conn.params["locale"]
    is_ietf_tag = BCP47.valid?(locale, ietf_only: true)

    if is_ietf_tag && locale in CableCarSpotter.Gettext.supported_locales do
      conn |> assign_locale!(locale)
    else
      locale = List.first(extract_locale(conn)) || default

      path = if is_ietf_tag do
        localized_path(conn.request_path, locale, conn.params["locale"])
      else
        localized_path(conn.request_path, locale)
      end
      conn |> redirect_to(path)
    end
  end

  defp assign_locale!(conn, value) do
    Gettext.put_locale(CableCarSpotter.Gettext, value)
    conn |> assign(:locale, value)
  end

  defp extract_locale(conn) do
    if Blank.present? conn.params["locale"] do
      [conn.params["locale"] | extract_accept_language(conn)]
    else
      extract_accept_language(conn)
    end
    |> Enum.filter(fn locale ->
      Enum.member?(CableCarSpotter.Gettext.supported_locales, locale)
    end)
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
    ~r/(\/)#{original}(\/(?:.+)?|\?(?:.+)?|$)/
    |> Regex.replace(request_path, "\\1#{locale}\\2")
  end

  defp localized_path(request_path, locale) do
    # If locale is not an ietf tag, it is a page request.
    "/#{locale}#{request_path}"
  end

  defp redirect_to(conn, path) do
    path = case Blank.present? conn.query_string do
      true -> path <> "?#{conn.query_string}"
      _ -> path
    end
    conn |> Phoenix.Controller.redirect(to: path)
  end
end
