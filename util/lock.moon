resty_lock = require "resty.lock"

lock = (dict, name, action) ->
    mutex = resty_lock\new dict
    elapsed, err = mutex\lock name
    return nil, err if err

    res = action!

    ok, err = mutex\unlock!
    return nil, err unless ok

    res

return lock
