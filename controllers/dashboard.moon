lapis = require "lapis"
util = require "lapis.util"

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

    [home: ""]: =>
        render: "dashboard.home", layout: false

    [listings: "/listings"]: =>
        render: "dashboard.my_listings", layout: false

    [wishlist: "/wishlist"]: =>
        render: "dashboard.wishlist", layout: false

    [messages: "/messages"]: =>
        render: "dashboard.messages", layout: false

    [settings: "/settings"]: =>
        render: "dashboard.settings", layout: false

    [new_house: "/new_housing_post"]: =>
        render: "housing.new_housing_post", layout: false

    [new_book: "/new_book_post"]: =>
        render: "books.new_book_post", layout: false


