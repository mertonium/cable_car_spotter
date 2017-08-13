defmodule CableCarSpotterWeb.Gettext do
  @moduledoc """
  A module providing Internationalization with a gettext-based API.

  By using [Gettext](https://hexdocs.pm/gettext),
  your module gains a set of macros for translations, for example:

      import CableCarSpotter.Gettext

      # Simple translation
      gettext "Here is the string to translate"

      # Plural translation
      ngettext "Here is the string to translate",
               "Here are the strings to translate",
               3

      # Domain-based translation
      dgettext "errors", "Here is the error message to translate"

  See the [Gettext Docs](https://hexdocs.pm/gettext) for detailed usage.
  """
  use Gettext, otp_app: :cable_car_spotter

  def supported_locales do
    known = Gettext.known_locales(CableCarSpotterWeb.Gettext)
    allowed = Application.get_env(:cable_car_spotter, __MODULE__)[:locales]

    Set.intersection(Enum.into(known, MapSet.new), Enum.into(allowed, MapSet.new))
    |> Set.to_list
  end
end
