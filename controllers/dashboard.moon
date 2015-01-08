lapis = require "lapis"
util = require "lapis.util"

class Dashboard extends lapis.Application

    [dashboard_home: "/dashboard"]: =>
        render: "dashboard.home", layout: false

    [my_listings: "/dashboard/listings"]: =>
        render: "dashboard.my_listings", layout: false

    [edit_profile: "/dashboard/profile"]: =>
        render: "dashboard.edit_profile", layout: false

    [edit_profile: "/dashboard/messages"]: =>
        render: "dashboard.messages", layout: false

