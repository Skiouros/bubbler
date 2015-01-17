lapis = require "lapis"
models = require "models"

class Books extends lapis.Application

    [details: "/b/:id"]: =>
        book = models.Posts\get type: "book", hash: @params.id
        return redirect_to: @url_for "landing" unless book
        @user = models.Users\find book.user_id

        @copyright = "Bubbler © #{os.date "%Y"}"
        @seller_profile = "Test User"
        @seller_name = "John Doe"
        @home_link = "v31adv"
        @book = book
        render: "books.book_post", layout: false

    [search: "/s/:school/books"]: =>
        @copyright = "Bubbler © #{os.date "%Y"}"
        @seller_profile = "Test User"
        @seller_name = "John Doe"
        @home_link = "v31adv"
        @school_name = "University of Somewhere"
        @srch_default_txt = "Search by college campus"
        @srch_placeholder = "Search for books..."
        render: "books.book_search", layout: false
