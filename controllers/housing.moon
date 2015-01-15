lapis = require "lapis"
util = require "lapis.util"

class Housing extends lapis.Application

    [home_details: "/h/:id"]: =>
        @copyright = "Bubbler © #{os.date "%Y"}"
        @seller_profile = "Test User"
        @seller_name = "John Doe"
        @home_link = "v31adv"
        render: "housing.home_post", layout: false

    [housing_search: "/s/:school/housing"]: =>
        @copyright = "Bubbler © #{os.date "%Y"}"
        @seller_profile = "Test User"
        @seller_name = "John Doe"
        @home_link = "v31adv"
        @school_name = "University of Somewhere"
        @srch_default_txt = "Search by college campus"
        @srch_placeholder = "Search for housing..."
        render: "housing.housing_search", layout: false