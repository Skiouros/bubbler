config = require "lapis.config"

get_cpu_count = ->
    handle = io.popen "nproc"
    n = handle\read "*a"
    handle\close!
    return tonumber n

config "development", ->
    port 8000
    code_cache "off"
    num_workers get_cpu_count!
    measure_performance true
    secret os.getenv "SECRET"

    email_key "api:#{os.getenv("MAILGUN_APIKEY")}"
    email_sender "bubb@bubbler.in"
    email_domain "bubbler.in"

    redis_host os.getenv "CACHE_PORT_6379_TCP_ADDR"

    postgres ->
        host os.getenv "DB_PORT_5432_TCP_ADDR"
        user "postgres"
        backend "pgmoon"
        password "password"
        database "postgres"

