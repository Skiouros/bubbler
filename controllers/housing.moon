lapis = require "lapis"
models = require "models"

class Housing extends lapis.Application

    [details: "/h/:id"]: =>
        house = models.Posts\get type: "house", hash: @params.id
        return redirect_to: @url_for "landing" unless house

        @user = models.Users\find house.user_id
        @house = house
        @address = "#{@house.address}, #{@house.city} #{@house.state}"
        render: "housing.home_post", layout: false

    [search: "/s/:school/housing"]: =>
        @seller_profile = "Test User"
        @seller_name = "John Doe"
        @home_link = "v31adv"
        @school_name = "University of Somewhere"
        @srch_default_txt = "Search by college campus"
        @srch_placeholder = "Search for housing..."
        render: "housing.housing_search", layout: false
