defmodule BCP47 do
  @moduledoc ~S"""
  Main BCP47 module.

  The `BCP47` module provides a parser for
  [bcp 47](https://tools.ietf.org/html/bcp47) spec'd language tags.
  """

  @type tag :: String.t

  @doc """
  Gets the locale for the current process and the given backend.

  This function returns the value of the locale for the current process and the
  given `backend`. If there is no locale for the current process and the given
  backend, the default locale is set as the locale for the current process and
  the given backend and then returned. For more information on the default
  locale and how it can be set, refer to the documentation of the `Gettext`
  module.

  ## Examples

      BCP47.parse("hy-Latn-IT-arevela")
      #=> %{
        langtag: %{
          language: %{ language: "hy", extlang: [] },
          script: "Latn",
          region: "IT",
          variant: ["arevela"],
          extension: [],
          privateuse: []
        },
        privateuse: [],
        grandfathered: %{ irregular: nil, regular: nil }
      }
  """
  @spec parse(tag) :: %{}
  def parse(tag) do
    cond do
      # Return :error for nil values and non-matches
      tag == nil -> {:error, "Param 'tag' cannot be nil."}
      !valid?(tag) -> {:error, "Param 'tag' with value is invaild."}
      # Parse otherwise
      true ->
        captures = Regex.named_captures(expression, tag)
        {:ok, %{
          langtag: %{
            language: extract_language(captures["language"]),
            script: captures["script"],
            region: captures["region"],
            variant: extract_variants(captures["variant"]),
            extension: extract_extensions(captures["extension"]),
            privateuse: extract_private(captures["lang_private"])
          },
          privateuse: extract_private(captures["private"]),
          grandfathered: %{
            irregular: captures["gf_irregular"],
            regular: captures["gf_regular"]
          }
        }}
    end
  end

  @spec valid?(tag, Keywort.t) :: boolean
  def valid?(tag, opts \\ []) do
    if opts[:ietf_only] do
      valid_ietf? tag
    else
      Blank.present?(tag) && Regex.match?(expression, tag)
    end
  end

  defp valid_ietf?(tag) do
    Blank.present?(tag) && String.downcase(tag) in ietf_codes
  end

  defp expression() do
    ~r/^(?:(?<gf_irregular>en-GB-oed|i-ami|i-bnn|i-default|i-enochian|i-hak|i-klingon|i-lux|i-mingo|i-navajo|i-pwn|i-tao|i-tay|i-tsu|sgn-BE-FR|sgn-BE-NL|sgn-CH-DE)|(?<gf_regular>art-lojban|cel-gaulish|no-bok|no-nyn|zh-guoyu|zh-hakka|zh-min|zh-min-nan|zh-xiang))$|^(?<language>(?:[a-z]{2,3}(?:(?:-[a-z]{3}){1,3})?)|[a-z]{4}|[a-z]{5,8})(?:-(?<script>[a-z]{4}))?(?:-(?<region>[a-z]{2}|\d{3}))?(?<variant>(?:-(?:[\da-z]{5,8}|\d[\da-z]{3}))*)?(?<extension>(?:-[\da-wy-z](?:-[\da-z]{2,8})+)*)?(?<lang_private>-x(?:-[\da-z]{1,8})+)?$|^(?<private>x(?:-[\da-z]{1,8})+)$/i
  end

  defp extract_language(string) do
    [language|extlang] = string |> String.split("-")
    %{ language: language, extlang: extlang }
  end

  defp extract_variants(string) do
    [_|variants] = string |> String.split("-")
    variants
  end

  defp extract_extensions(string) do
    ~r/-([\da-wy-z](?:-[\da-z]{2,8})+)/i
    |> Regex.scan(string, capture: :all_but_first)
    |> List.flatten
    |> Enum.map(fn match ->
      [singleton|values] = String.split(match, "-")
      %{ singleton: singleton, values: values }
    end)
  end

  defp extract_private(string) do
    ~r/(x(?:-[\da-z]{1,8})+)/i
    |> Regex.scan(string, capture: :all_but_first)
    |> List.flatten
    |> Enum.flat_map(fn match ->
      [_|values] = String.split(match, "-")
      values
    end)
  end

  defp ietf_codes do
    ~w(af af-na af-za agq agq-cm ak ak-gh am am-et ar ar-001 ar-ae ar-bh ar-dj ar-dz ar-eg ar-eh ar-er ar-il ar-iq ar-jo ar-km ar-kw ar-lb ar-ly ar-ma ar-mr ar-om ar-ps ar-qa ar-sa ar-sd ar-so ar-ss ar-sy ar-td ar-tn ar-ye as as-in asa asa-tz ast ast-es az az-cyrl az-cyrl-az az-latn az-latn-az bas bas-cm be be-by bem bem-zm bez bez-tz bg bg-bg bm bm-latn bm-latn-ml bn bn-bd bn-in bo bo-cn bo-in br br-fr brx brx-in bs bs-cyrl bs-cyrl-ba bs-latn bs-latn-ba ca ca-ad ca-es ca-es-valencia ca-fr ca-it cgg cgg-ug chr chr-us cs cs-cz cy cy-gb da da-dk da-gl dav dav-ke de de-at de-be de-ch de-de de-li de-lu dje dje-ne dsb dsb-de dua dua-cm dyo dyo-sn dz dz-bt ebu ebu-ke ee ee-gh ee-tg el el-cy el-gr en en-001 en-150 en-ag en-ai en-as en-au en-bb en-be en-bm en-bs en-bw en-bz en-ca en-cc en-ck en-cm en-cx en-dg en-dm en-er en-fj en-fk en-fm en-gb en-gd en-gg en-gh en-gi en-gm en-gu en-gy en-hk en-ie en-im en-in en-io en-je en-jm en-ke en-ki en-kn en-ky en-lc en-lr en-ls en-mg en-mh en-mo en-mp en-ms en-mt en-mu en-mw en-my en-na en-nf en-ng en-nr en-nu en-nz en-pg en-ph en-pk en-pn en-pr en-pw en-rw en-sb en-sc en-sd en-sg en-sh en-sl en-ss en-sx en-sz en-tc en-tk en-to en-tt en-tv en-tz en-ug en-um en-us en-us-posix en-vc en-vg en-vi en-vu en-ws en-za en-zm en-zw eo eo-001 es es-419 es-ar es-bo es-cl es-co es-cr es-cu es-do es-ea es-ec es-es es-gq es-gt es-hn es-ic es-mx es-ni es-pa es-pe es-ph es-pr es-py es-sv es-us es-uy es-ve et et-ee eu eu-es ewo ewo-cm fa fa-af fa-ir ff ff-cm ff-gn ff-mr ff-sn fi fi-fi fil fil-ph fo fo-fo fr fr-be fr-bf fr-bi fr-bj fr-bl fr-ca fr-cd fr-cf fr-cg fr-ch fr-ci fr-cm fr-dj fr-dz fr-fr fr-ga fr-gf fr-gn fr-gp fr-gq fr-ht fr-km fr-lu fr-ma fr-mc fr-mf fr-mg fr-ml fr-mq fr-mr fr-mu fr-nc fr-ne fr-pf fr-pm fr-re fr-rw fr-sc fr-sn fr-sy fr-td fr-tg fr-tn fr-vu fr-wf fr-yt fur fur-it fy fy-nl ga ga-ie gd gd-gb gl gl-es gsw gsw-ch gsw-fr gsw-li gu gu-in guz guz-ke gv gv-im ha ha-latn ha-latn-gh ha-latn-ne ha-latn-ng haw haw-us he he-il hi hi-in hr hr-ba hr-hr hsb hsb-de hu hu-hu hy hy-am id id-id ig ig-ng ii ii-cn is is-is it it-ch it-it it-sm ja ja-jp jgo jgo-cm jmc jmc-tz ka ka-ge kab kab-dz kam kam-ke kde kde-tz kea kea-cv khq khq-ml ki ki-ke kk kk-cyrl kk-cyrl-kz kkj kkj-cm kl kl-gl kln kln-ke km km-kh kn kn-in ko ko-kp ko-kr kok kok-in ks ks-arab ks-arab-in ksb ksb-tz ksf ksf-cm ksh ksh-de kw kw-gb ky ky-cyrl ky-cyrl-kg lag lag-tz lb lb-lu lg lg-ug lkt lkt-us ln ln-ao ln-cd ln-cf ln-cg lo lo-la lt lt-lt lu lu-cd luo luo-ke luy luy-ke lv lv-lv mas mas-ke mas-tz mer mer-ke mfe mfe-mu mg mg-mg mgh mgh-mz mgo mgo-cm mk mk-mk ml ml-in mn mn-cyrl mn-cyrl-mn mr mr-in ms ms-latn ms-latn-bn ms-latn-my ms-latn-sg mt mt-mt mua mua-cm my my-mm naq naq-na nb nb-no nb-sj nd nd-zw ne ne-in ne-np nl nl-aw nl-be nl-bq nl-cw nl-nl nl-sr nl-sx nmg nmg-cm nn nn-no nnh nnh-cm nus nus-sd nyn nyn-ug om om-et om-ke or or-in os os-ge os-ru pa pa-arab pa-arab-pk pa-guru pa-guru-in pl pl-pl ps ps-af pt pt-ao pt-br pt-cv pt-gw pt-mo pt-mz pt-pt pt-st pt-tl qu qu-bo qu-ec qu-pe rm rm-ch rn rn-bi ro ro-md ro-ro rof rof-tz root ru ru-by ru-kg ru-kz ru-md ru-ru ru-ua rw rw-rw rwk rwk-tz sah sah-ru saq saq-ke sbp sbp-tz se se-fi se-no se-se seh seh-mz ses ses-ml sg sg-cf shi shi-latn shi-latn-ma shi-tfng shi-tfng-ma si si-lk sk sk-sk sl sl-si smn smn-fi sn sn-zw so so-dj so-et so-ke so-so sq sq-al sq-mk sq-xk sr sr-cyrl sr-cyrl-ba sr-cyrl-me sr-cyrl-rs sr-cyrl-xk sr-latn sr-latn-ba sr-latn-me sr-latn-rs sr-latn-xk sv sv-ax sv-fi sv-se sw sw-cd sw-ke sw-tz sw-ug ta ta-in ta-lk ta-my ta-sg te te-in teo teo-ke teo-ug th th-th ti ti-er ti-et to to-to tr tr-cy tr-tr twq twq-ne tzm tzm-latn tzm-latn-ma ug ug-arab ug-arab-cn uk uk-ua ur ur-in ur-pk uz uz-arab uz-arab-af uz-cyrl uz-cyrl-uz uz-latn uz-latn-uz vai vai-latn vai-latn-lr vai-vaii vai-vaii-lr vi vi-vn vun vun-tz wae wae-ch xog xog-ug yav yav-cm yi yi-001 yo yo-bj yo-ng zgh zgh-ma zh zh-hans zh-hans-cn zh-hans-hk zh-hans-mo zh-hans-sg zh-hant zh-hant-hk zh-hant-mo zh-hant-tw zu zu-za)
  end
end