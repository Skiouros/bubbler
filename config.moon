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

    email ->
        key "#{os.getenv("MAILGUN_APIKEY")}"
        sender "bubbs@bubbler.in"
        domain "bubbler.in"

    honcho ->
        delay 5
        workers_per_thread 5
        job_dir "jobs"
        hostname os.getenv "HOSTNAME"

    redis ->
        host os.getenv "CACHE_PORT_6379_TCP_ADDR"
        port 6379

    postgres ->
        host os.getenv "DB_PORT_5432_TCP_ADDR"
        user "postgres"
        backend "pgmoon"
        password "password"
        database "postgres"

