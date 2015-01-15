resty_redis = require "resty.redis"

Redis = {}
Redis.__index = (key) =>
        if val = Redis[key]
            return val
        return (_, ...) ->
            @run key, ...

Redis.new = (host, port) ->
    @ = {}
    @host = host
    @port = port
    @connected = false
    @autoclose = ""
    @redis_client, err = resty_redis\new!

    if err
        error "REDIS ERROR: #{err}"

    setmetatable @, Redis
    return @

Redis.done = =>
    if @autoclose == "keepalive"
        return @set_keepalive @time, @poolsize
    elseif @autoclose == "close"
        return @close!
    nil, "autoclose must be keepalive or close"

Redis.close = =>
    @connected = false
    @redis_client\close!

Redis.keepalive = (@time, @poolsize) =>

Redis.set_keepalive = (time = @time, poolsize = @poolsize) =>
    @connected = false
    @redis_client\set_keepalive time, poolsize

Redis.sync = (action) =>

Redis.run = (action, ...) =>
    unless @connected
        ok, err = @redis_client\connect @host, @port
        unless ok
            error "CONNECTING ERROR #{err}"
        @connected = true

    res, err = @redis_client[action] @redis_client, ...
    if res == nil
        res = ngx.null
    if err == "closed"
        @connected = false

    _, er = @done!
    return nil, er if er

    return res, err

Redis.multi = (action) =>
    ok, err = @redis_client\multi!
    unless ok
        return nil, err
    action @
    @redis_client\exec!

Redis.pipeline = (action) =>
    -- don't close redis conn during pipeline
    autoclose = @autoclose
    @autoclose = ""

    @init_pipeline!
    action @
    res, err = @commit_pipeline!

    @autoclose = autoclose
    res, err

return setmetatable Redis,
    __call: (...) =>
        return Redis.new ...
