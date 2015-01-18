lapis = require "lapis"
console = require "lapis.console"
config = require("lapis.config").get!

import entity_exists from require "lapis.db.schema"
Users = require "models.users"

import to_json from require "lapis.util"
import after_dispatch from require "lapis.nginx.context"
import send_email from require "helpers.email"

import respond_to, capture_errors_json from require "lapis.application"
import assert_valid from require "lapis.validate"

class App extends lapis.Application
    @enable "etlua"
    @include "controllers.users", name: "user_"
    @include "controllers.school", name: "school_"
    @include "controllers.dashboard", name: "dashboard_"
    @include "controllers.housing", name: "housing_"
    @include "controllers.books", name: "book_"

    @before_filter =>
        @copyright = "Bubbler © #{os.date "%Y"}"
        if @session.user and entity_exists "users"
            @current_user = Users\find @session.user.id

        after_dispatch ->
            print to_json(ngx.ctx.performance)

    [landing: "/"]: =>
        @copyright = "Bubbler © #{os.date "%Y"}"
        render: true, layout: false

    [feedback: "/feedback"]: respond_to {
        POST: capture_errors_json =>
            assert_valid @params, {
                { "from_email", exists: true }
                { "message", exists: true }
                { "from", exists: true }
            }

            send_email config.email.sender, "Feedback - #{@params.from}", @params.message, @params.from_email
            json: msg: "ok"
    }

    "/console": console.make!

    handle_404: =>
        status: 404, layout: false, "Not found"
