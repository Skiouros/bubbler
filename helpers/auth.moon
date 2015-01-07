require_login = (fn) ->
    =>
        if @current_user
            fn @
        else
            redirect_to: @url_for "user_login"

{ :require_login }
