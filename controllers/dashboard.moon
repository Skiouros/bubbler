lapis = require "lapis"
models = require "models"

import validate_functions, assert_valid from require "lapis.validate"
import respond_to, assert_error, capture_errors, capture_errors_json, yield_error from require "lapis.application"
import require_login from require "helpers.auth"

books_errors = {
    ['duplicate key value violates unique constraint']: "post with title already exists"
}
book_get_error = (err) ->
    pos = string.find err, "ERROR: "
    err = string.sub err, pos + 6, #err
    return unless err

    for msg, res in pairs books_errors
        if string.find err, msg
            return res

active_menu = (menu_item, current) ->
    return 'class=menu_active' if menu_item == current
    ""

class Dashboard extends lapis.Application
    @path: "/dashboard"

    @before_filter =>
        -- TODO: move these elsewhere
        @copyright = "Bubbler © #{os.date "%Y"}"
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

    [new_house: "/new_house"]: require_login =>
        render: "housing.new_housing_post", layout: false

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
            -- TODO: custom validation for isbn
            data =
                condition: @params.condition
                author: @params.author
                subject: @params.subject
                type: @params.type
                course: @params.course
                publisher: @params.publisher
                edition: @params.edition
                isbn_10: @params.isbn_10
                isbn_13: @params.isbn_13

            post, err = models.Posts\create @current_user,
                @params.title, @params.description,
                @params.price, "book", data

            yield_error book_get_error err if err


        GET: =>
            render: "books.new_book_post", layout: false
    }


