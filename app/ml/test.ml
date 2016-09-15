module G = Cordova_globalization

let doc = Dom_html.document

let create_p s =
  let p = Dom_html.createP doc in
  p##.innerHTML := (Js.string s);
  p

let get_value_int s =
  let v = G.Number.value s in
  Dom.appendChild doc##.body (create_p (string_of_float v))

let get_value_str s =
  let v = G.LString.value s in
  Dom.appendChild doc##.body (create_p v)

let get_value_date (s : G.DatePattern.t) =
  let utc = G.DatePattern.utc_offset s in
  let dst = G.DatePattern.dts_offset s in
  let str =
    "Pattern: " ^ (G.DatePattern.pattern s) ^ "<br />" ^
    "Timezone: " ^ (G.DatePattern.timezone s) ^ "<br />" ^
    "Utc_offset: " ^ (string_of_int utc) ^ "<br />" ^
    "dst_offset: " ^ (string_of_int dst)
  in
  Dom.appendChild doc##.body (create_p str)

let get_value_currency s =
  let fraction = G.CurrencyPattern.fraction s in
  let rounding = G.CurrencyPattern.rounding s in
  let str =
    "Pattern: " ^ (G.CurrencyPattern.pattern s) ^ "<br />" ^
    "Code: " ^ (G.CurrencyPattern.code s) ^ "<br />" ^
    "Fraction: " ^ (string_of_int fraction) ^ "<br />" ^
    "Rounding: " ^ (string_of_int rounding) ^ "<br />" ^
    "Decimal: " ^ (G.CurrencyPattern.decimal s) ^ "<br />" ^
    "Grouping: " ^ (G.CurrencyPattern.grouping s)
  in
  Dom.appendChild doc##.body (create_p str)

let on_device_ready () =
  G.get_preferred_language
    get_value_str
    (fun () -> Jsoo_lib.console_log "Error");

  G.get_locale_name get_value_str
    (fun () -> Jsoo_lib.console_log "Error");

  G.date_to_string
    (Js_date.now ())
    get_value_str
    (fun () -> Jsoo_lib.console_log "Error")
    ();

  G.get_first_day_of_week
    get_value_int
    (fun () -> Jsoo_lib.console_log "Error");

  G.get_date_pattern
    get_value_date
    (fun () -> Jsoo_lib.console_log "Error")
    ();

  G.get_currency_pattern
    "USD"
    get_value_currency
    (fun () -> Jsoo_lib.console_log "Error")

let _ =
  Cordova.Event.device_ready on_device_ready
