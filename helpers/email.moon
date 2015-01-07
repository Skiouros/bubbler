ltn12 = require "ltn12"

http = require "lapis.nginx.http"
config = require("lapis.config").get!

import encode_query_string from require "lapis.util"
import encode_base64 from require "lapis.util.encoding"

import concat from table

send_email = if config.email_key
  (to, subject, body, opts={}) ->
    out = {}
    res = http.request {
      url: "https://api.mailgun.net/v2/#{config.email_domain}/messages"
      source: ltn12.source.string encode_query_string {
        to: to
        from: config.email_sender
        subject: subject
        [opts.html and "html" or "text"]: body
      }
      headers: {
        "Content-type": "application/x-www-form-urlencoded"
        "Authorization": "Basic " .. encode_base64 config.email_key
      }
      sink: ltn12.sink.table out
    }

    concat(out), res
else
  ->


{ :send_email }
