seeker = require "util.seeker"
config = require("lapis.config").get!

send_email = if config.email.key
    (to, subject, body, frm = config.email.sender) ->
        res, err = seeker.post "https://api.mailgun.net/v3/#{config.email.domain}/messages",
            auth: { "api", config.email.key }
            data: {
                to: to
                text: body
                subject: subject
                from: frm
            }
        return nil, err if err

        json, err = res\json!
        return nil, err if err

        return nil, "failed to queue" unless json.message == "Queued. Thank you."
        return true
    else
        ->

{ :send_email }
