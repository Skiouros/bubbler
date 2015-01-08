lapis = require "lapis"
console = require "lapis.console"

Users = require "models.users"

import to_json from require "lapis.util"
import after_dispatch from require "lapis.nginx.context"

class App extends lapis.Application
    @enable "etlua"
    @include "controllers.users", name: "user_"
    @include "controllers.dashboard", name: "dashboard_"
    @include "controllers.housing", name: "housing_"
    @include "controllers.books", name: "books_"

    @before_filter =>
        if @session.user
            @current_user = Users\find @session.user.id

        after_dispatch ->
            print to_json(ngx.ctx.performance)

    [landing: "/"]: =>
        @copyright = "Bubbler © #{os.date "%Y"}"
        render: true, layout: false

    "/console": console.make!

    handle_404: =>
        status: 404, layout: false, "Not found"
