lapis = require "lapis"
models = require "models"

import validate_functions, assert_valid from require "lapis.validate"
import respond_to, assert_error, capture_errors, capture_errors_json, yield_error from require "lapis.application"
import require_login from require "helpers.auth"

book_errors = {
    ['duplicate key value violates unique constraint']: "post with title already exists"
}

house_errors = {
    ['duplicate key value violates unique constraint']: "post with title already exists"
}

book_fields = {
    "condition", "author", "subject", "type", "course",
    "publisher", "edition", "isbn_10", "isbn_13",
}

house_fields = {
    "purchase_type", "home_type", "address", "city", "state",
    "lease", "lease_duration", "rooms", "about"
}

get_error = (tbl, err) ->
    pos = string.find err, "ERROR: "
    err = string.sub err, pos + 6, #err
    return unless err

    for msg, res in pairs tbl
        if string.find err, msg
            return res

active_menu = (menu_item, current) ->
    return 'class=menu_active' if menu_item == current
    ""

class Dashboard extends lapis.Application
    @path: "/dashboard"

    @before_filter =>
        -- TODO: move these elsewhere
        @srch_default_txt = "Search by college campus"
        @active_menu = (name) =>
            active_menu "dashboard_#{name}", @route_name

    [home: ""]: require_login =>
        render: "dashboard.home", layout: false

    [listings: "/listings"]: require_login =>
        render: "dashboard.my_listings", layout: false

    [wishlist: "/wishlist"]: require_login =>
        render: "dashboard.wishlist", layout: false

    [messages: "/messages"]: require_login =>
        render: "dashboard.messages", layout: false

    [settings: "/settings"]: require_login =>
        render: "dashboard.settings", layout: false

    [new_house: "/new_house"]: require_login respond_to {
        POST: capture_errors_json =>
            assert_valid @params, {
                { "title", exists: true }
                { "purchase_type", exists: true }
                { "home_type", exists: true }
                { "address", exists: true }
                { "city", exists: true }
                { "state", exists: true }
                { "price", exists: true, is_integer: true, "price must be a number" }
                { "lease", exists: true }
                { "lease_duration", exists: true }
                { "rooms", exists: true }
                { "about", exists: true }
                { "description", exists: true }
            }

            data = {}
            data[k] = @params[k] for k in *house_fields

            -- access raw post args to get values from checkboxes
            -- because lapis flattens them for some reason
            args = ngx.req.get_post_args!
            data.amenities =  args.amenities
            data.extra_features =  args.extra_features

            post, err = models.Posts\create @current_user,
                @params.title, @params.description,
                @params.price, "house", data

            yield_error get_error house_errors, err if err

        GET: =>
            render: "housing.new_housing_post", layout: false
    }

    [new_book: "/new_book"]: require_login respond_to {
        POST: capture_errors_json =>
            assert_valid @params, {
                { "title", exists: true }
                { "type", exists: true }
                { "author", exists: true }
                { "condition", exists: true }
                { "description", exists: true }
                { "subject", exists: true }
                { "price", exists: true, is_integer: true, "price must be a number" }
            }

            if @params.isbn_10 == "" and @params.isbn_13 == ""
                yield_error "isbn need at least one"

            data = {}
            data[k] = @params[k] for k in *book_fields

            post, err = models.Posts\create @current_user,
                @params.title, @params.description,
                @params.price, "book", data

            yield_error get_error book_errors, err if err


        GET: =>
            render: "books.new_book_post", layout: false
    }


