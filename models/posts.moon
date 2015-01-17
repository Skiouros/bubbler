import Model from require "lapis.db.model"
import to_json, from_json from require "lapis.util"

db = require "lapis.db"
models = require "models"

class Posts extends Model
    @table_name: => "posts"
    @primary_key: {"user_id", "title"}
    @timestamp: true

    @create: (user, title, desc, price, typ, data) =>
        info =
            user_id: user.id, data: to_json data
            :price, :title, description: desc, type: typ
        info.hash = string.sub ngx.md5(to_json data), 1, 8
        ok, res = pcall Model.create, @, info
        return nil, res unless ok
        res

    @get_all: (id, typ) =>
        posts = @select "where user_id = ? and type = ?", id, typ
        return nil if not posts

        for post in *posts
            post\get_json!
        posts

    @get: (...) =>
        post = @find ...
        return nil if not post
        post\get_json!

    get_json: =>
        for k, v in pairs from_json(@data)
            @[k] = v
        @

