Redis = require "util.redis"
Honcho = require "honcho.honcho"
Register = require "honcho.register"

import autoload, trim_all from require "lapis.util"
config = require("lapis.config").get!
-- TODO: come up with better handling of config

queues_tag = config.honcho.queues or "*"
workers_per_thread = config.honcho.workers_per_thread or 5

local queues
get_queues = (honcho) ->
    return queues if queues
    return honcho\get_queues! if queues_tag == "*"

    -- split str by ,
    res = { string.match queues, "([^,]+),([^,]+)" }
    if #res == 0
        res = { str }

    queues = trim_all res
    return queues

create_timer = (delay, action, ...) ->
    ok, err = ngx.timer.at delay, action, ...
    unless ok
        ngx.log ngx.ERR, "failed to create timer: ", err

local Worker
work = (premature, id, delay) ->
    return if premature

    honcho = Honcho with Redis config.redis.host, config.redis.port
        .autoclose = "keepalive"
        \keepalive 10 * 1000, 30

    worker = Worker honcho, id
    with Register honcho
        \set_poller id, delay + 5

    for queue in *get_queues honcho
        payload, err = honcho\pop queue
        continue if err or payload == ngx.null

        ok, err = worker\run queue, payload
        ngx.log ngx.ERR, "job failed: ", err unless ok

check = (delay) ->
    for i = 1, workers_per_thread
        id = "#{ngx.worker.pid()}:#{queues_tag}"
        create_timer 0, work, "#{config.honcho.hostname}:poller-#{id}", delay

class Worker
    new: (@honcho, @id) =>

    get_class: (name) =>
        jobs = autoload config.honcho.job_dir
        jobs[name]

    run: (queue, payload) =>
        if err = @work queue, payload
            info =
                :err, :payload, :queue, worker: @id
                retried_at: "", failed_at: ngx.utctime!
            @honcho\failed_job queue, info
            return nil, err
        @honcho.redis\incr "#{@honcho.namespace}:stat:processed"

    work: (queue, payload) =>
        klass = @get_class payload.class
        klass.preform unpack(payload.args)

return check
