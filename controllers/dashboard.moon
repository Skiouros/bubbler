lapis = require "lapis"
util = require "lapis.util"

class Dashboard extends lapis.Application

    [dashboard_home: "/dashboard"]: =>
        @srch_default_txt = "Search by college campus"
        @copyright = "Bubbler © #{os.date "%Y"}"
        render: "dashboard.home", layout: false

    [my_listings: "/dashboard/listings"]: =>
        @srch_default_txt = "Search by college campus"
        @copyright = "Bubbler © #{os.date "%Y"}"
        render: "dashboard.my_listings", layout: false

    [edit_profile: "/dashboard/profile"]: =>
        @srch_default_txt = "Search by college campus"
        @copyright = "Bubbler © #{os.date "%Y"}"
        render: "dashboard.edit_profile", layout: false

    [messages: "/dashboard/messages"]: =>
        @srch_default_txt = "Search by college campus"
        @copyright = "Bubbler © #{os.date "%Y"}"
        render: "dashboard.messages", layout: false

    [account_settings: "/dashboard/account_settings"]: =>
        @srch_default_txt = "Search by college campus"
        @copyright = "Bubbler © #{os.date "%Y"}"
        render: "dashboard.account_settings", layout: false

    [new_housing_post: "/dashboard/new_housing_post"]: =>
        @srch_default_txt = "Search by college campus"
        @copyright = "Bubbler © #{os.date "%Y"}"
        render: "housing.new_housing_post", layout: false

    [new_book_post: "/dashboard/new_book_post"]: =>
        @srch_default_txt = "Search by college campus"
        @copyright = "Bubbler © #{os.date "%Y"}"
        render: "books.new_book_post", layout: false


