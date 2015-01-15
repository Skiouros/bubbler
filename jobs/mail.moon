import send_email from require "helpers.email"

class Mail
    @queue: "mail"

    @preform: (to, subject, body) ->
        ok, err = send_email to, subject, body
        return err unless ok
