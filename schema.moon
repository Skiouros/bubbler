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

        {"created_at", time}
        {"updated_at", time}

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

{ :make_schema }
