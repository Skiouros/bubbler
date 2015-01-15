class Register
    new: (@honcho) =>
        @redis = honcho.redis

    set_poller: (name, expire) =>
        name = "#{@honcho.namespace}:worker:#{name}"
        @redis\set name, true, "NX", "EX", expire
