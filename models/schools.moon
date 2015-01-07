import Model from require "lapis.db.model"

db = require "lapis.db"

class Schools extends Model
    @table_name: => "schools"
    @primary_key: "name"

    @create: (name) =>
        if @check_unique_constraint "name", name
            return nil, "School already added"

        Model.create @, {
            :name
        }

    @get_all: =>
        db.query "SELECT * FROM SCHOOLS"

