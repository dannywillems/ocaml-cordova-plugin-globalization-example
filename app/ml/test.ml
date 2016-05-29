let doc = Dom_html.document

let create_p s =
  let p = Dom_html.createP doc in
  p##.innerHTML := (Js.string s);
  p

let get_value_int s =
  Dom.appendChild doc##.body (create_p (string_of_float s#value))

let get_value_str s =
  Dom.appendChild doc##.body (create_p s#value)

let get_value_date s =
  let str =
    "Pattern: " ^ s#pattern ^ "<br />" ^
    "Timezone: " ^ s#timezone ^ "<br />" ^
    "Utc_offset: " ^ (string_of_int s#utc_offset) ^ "<br />" ^
    "dst_offset: " ^ (string_of_int s#dst_offset)
  in
  Dom.appendChild doc##.body (create_p str)

let get_value_currency s =
  let str =
    "Pattern: " ^ s#pattern ^ "<br />" ^
    "Code: " ^ s#code ^ "<br />" ^
    "Fraction: " ^ (string_of_int s#fraction) ^ "<br />" ^
    "Rounding: " ^ (string_of_int s#rounding) ^ "<br />" ^
    "Decimal: " ^ s#decimal ^ "<br />" ^
    "Grouping: " ^ s#grouping
  in
  Dom.appendChild doc##.body (create_p str)

let on_device_ready () =
  let g = Cordova_globalization.t () in
  g#get_preferred_language
    get_value_str
    (fun () -> Jsoo_lib.console_log "Error");

  g#get_locale_name get_value_str
    (fun () -> Jsoo_lib.console_log "Error");

  g#date_to_string
    (Js_date.now ())
    get_value_str
    (fun () -> Jsoo_lib.console_log "Error")
    ();

  g#get_first_day_of_week
    get_value_int
    (fun () -> Jsoo_lib.console_log "Error");

  g#get_date_pattern
    get_value_date
    (fun () -> Jsoo_lib.console_log "Error")
    ();

  g#get_currency_pattern
    "USD"
    get_value_currency
    (fun () -> Jsoo_lib.console_log "Error")

let _ = Cordova.Event.device_ready on_device_ready
