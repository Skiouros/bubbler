import Model from require "lapis.db.model"

db = require "lapis.db"
bcrypt = require "bcrypt"
models = require "models"

class Users extends Model
    @table_name: => "users"
    @primary_key: "id"
    @timestamp: true

    @create: (name, password, email, school) =>
        encrypted_password = bcrypt.digest password, bcrypt.salt 5

        if @check_unique_constraint "email", email
            return nil, "email already taken"

        -- should exist, becuase we check at at /register
        school = models.Schools\find name: school
        unless school
            return nil, "Invalid school"

        Model.create @, {
            :name, :email, :encrypted_password, school: school.id
        }

    @read_session: (r) =>
        unless r.session.user return
        user = @find r.session.user.id
        if user and user\salt! == r.session.user.key
            user

    @login: (email, password) =>
        -- TODO: Might have to use db.raw "lower(email)"
        user = Users\find email: email
        if user then user\get_data!

        if user and user\check_password(password) and user.data.email_verified
            user
        elseif user and user\check_password(password) and not user.data.email_verified
            nil, "must activate account"
        else
            nil, "Incorrect email or password"

    get_school: =>
        models.Schools\find(id: @school).name

    get_posts: (typ) =>
        posts = models.Posts\get_all @id, typ
        post.user = @ for post in *posts
        posts

    get_link: =>


    get_data: =>
        return if @data
        @data = models.UserData\find(@id) or models.UserData\create(@id)
        @data

    update_password: (password) =>
        @update encrypted_password: bcrypt.digest password, bcrypt.salt 5

    check_password: (password) =>
        bcrypt.verify password, @encrypted_password

    write_session: (r) =>
        r.session.user = {
            id: @id
            key: @salt!
        }

    salt: =>
        @encrypted_password\sub 1, 29
