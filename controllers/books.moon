lapis = require "lapis"
util = require "lapis.util"

class Books extends lapis.Application

    [book_details: "/b/:id"]: =>
        @copyright = "Bubbler © #{os.date "%Y"}"
        @seller_profile = "Test User"
        @seller_name = "John Doe"
        @home_link = "v31adv"
        render: "books.book_post", layout: false

    [books_search: "/s/:school/books"]: =>
        @copyright = "Bubbler © #{os.date "%Y"}"
        @seller_profile = "Test User"
        @seller_name = "John Doe"
        @home_link = "v31adv"
        @school_name = "University of Somewhere"
        @srch_default_txt = "Search by college campus"
        @srch_placeholder = "Search for books..."
        render: "books.book_search", layout: false