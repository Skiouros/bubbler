lapis = require "lapis"
models = require "models"
encoding = require "lapis.util.encoding"

import validate_functions, assert_valid from require "lapis.validate"
import respond_to, assert_error, capture_errors, capture_errors_json, yield_error from require "lapis.application"
import send_email from require "helpers.email"
import require_login from require "helpers.auth"

validate_functions.email_ext = (input, ext) ->
    ending = string.sub input, #input - (#ext - 1), #input
    ending == ext, "%s must be #{ext}"

validate_functions.college_exists = (input) ->
    school = models.Schools\find name: input
    school != nil, "%s not supported yet"

validate_token = =>
    encoded_str = encoding.decode_base64 @params.splat
    yield_error "invalid link" unless encoded_str

    obj = assert_error encoding.decode_with_secret(encoded_str), "invalid link"
    user = models.Users\find obj.id
    yield_error "invalid link" unless user

    -- if its been over 24 hour since issued
    if ((os.time! - obj.time) / 60) > (60 * 24)
       assert_error false, "invalid link"

    return user, obj

validate_password_reset = =>
    user, obj = validate_token @
    if user\salt! != obj.salt
        yield_error "link expired"

    return user

class Users extends lapis.Application
    [verify: "/verify/*"]: capture_errors {
        on_error: =>
            json: @errors
        =>
            user = validate_token @
            user\get_data!
            user.data\update email_verified: true
            redirect_to: @url_for "user_login", status: 301
    }

    [reset_password: "/reset_password/*"]: respond_to {
        GET: capture_errors {
            on_error: =>
                json: @errors
             =>
                validate_password_reset @
                render: "user.reset_password", layout: false
        }

        POST: capture_errors_json =>
            assert_valid @params, {
                { "password", exists: true }
                { "password_repeat", equals: @params.password, "passwords must match" }
            }
            user = validate_password_reset @
            user\update_password @params.password
            json: redirect_to: @url_for "user_login"
    }

    [register: "/register"]: respond_to {
        POST: capture_errors_json =>
            assert_valid @params, {
                { "fullname", exists: true }
                { "email", exists: true }
                { "password", exists: true, min_length: 4 }
                { "college", exists: true, college_exists: true }
            }
            user = assert_error models.Users\create @params.fullname, @params.password, @params.email, @params.college

            url = string.sub @build_url(@url_for "user_verify"), 1, -2
            url ..= encoding.encode_base64 encoding.encode_with_secret
                id: user.id, time: os.time!

            send_email user.email, "Registration", "Goto #{url} to register."
            json: msg: "Check your email to continue"
    }

    [login: "/login"]: respond_to {
        POST: capture_errors_json =>
            assert_valid @params, {
                { "email", exists: true }
                { "password", exists: true }
            }
            user, err = models.Users\login @params.email, @params.password
            if err == "must activate account"
                return json: needs_activate: true
            elseif err
                yield_error err

            user\write_session @
            json: redirect_to: "/u/#{user.id}"

        GET: =>
            return redirect_to: "/u/#{@current_user.id}" if @current_user
            render: "user.login", layout: false
    }

    [logout: "/logout"]: =>
        @session.user = nil
        redirect_to: @url_for "user_login"


    [forgot_password: "/forgot_password"]: respond_to {
        POST: capture_errors_json =>
            assert_valid @params, {
                { "email", exists: true }
            }
            user = models.Users\find email: @params.email
            unless user
                yield_error "email not found"

            url = string.sub @build_url(@url_for "user_reset_password"), 1, -2
            url ..= encoding.encode_base64 encoding.encode_with_secret
                id: user.id, time: os.time!, salt: user\salt!

            send_email user.email, "Forgot Password", "Goto #{url} to set new password"
            json: sent: true

        GET: =>
            render: "user.forgot_password", layout: false
    }

    [profile: "/u/:id"]: require_login capture_errors {
        on_error: =>
            redirect_to: @url_for "landing"
        =>
            assert_valid @params, {
                { "id", is_integer: true }
            }
            @user = models.Users\find @params.id
            yield_error "invalid user" unless @user

            @books = @user\get_posts "book"
            @houses = { {} }
            render: "profile.public_profile", layout: false
    }
