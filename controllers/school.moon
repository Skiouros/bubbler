lapis = require "lapis"
util = require "lapis.util"

class School extends lapis.Application

    [school_home: "/s/:name"]: =>
        @school_name = @params.name
        @copyright = "Bubbler © #{os.date "%Y"}"
        render: "school.school_home", layout: false