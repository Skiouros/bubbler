db = require "lapis.nginx.postgres"
schema = require "lapis.db.schema"
migrations = require "lapis.db.migrations"

import
    create_table
    create_index
    drop_table from schema

make_schema = ->
    import
        serial
        varchar
        text
        time
        integer
        foreign_key
        boolean
        from schema.types

    create_table "users", {
        {"id", serial}
        {"name", varchar}
        {"encrypted_password", varchar}
        {"email", varchar}
        {"school", foreign_key}

        {"created_at", time timezone: true}
        {"updated_at", time timezone: true}

        "PRIMARY KEY (id)"
    }
    create_index "users", db.raw("lower(email)"), unique: true

    create_table "user_data", {
        {"user_id", foreign_key}
        {"email_verified", boolean}
        "PRIMARY KEY (user_id)"
    }

    create_table "schools", {
        {"id", serial}
        {"name", varchar}

        "PRIMARY KEY (name)"
    }
    create_index "schools", db.raw("lower(name)"), unique: true

    create_table "images", {
        {"post_id", foreign_key}
        {"location", varchar}

        "PRIMARY KEY (post_id, location)"
    }

    create_table "posts", {
        {"id", serial}
        {"user_id", foreign_key}
        {"title", varchar}
        {"description", varchar}
        {"type", varchar}
        {"hash", varchar}
        "price money"
        "data jsonb not null"

        {"created_at", time timezone: true}
        {"updated_at", time timezone: true}

        "PRIMARY KEY (user_id, title)"
    }
    create_index "posts", "data", method: "GIN"
{ :make_schema }
