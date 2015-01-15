lock = require "util.lock"
date = require "date"
events = {}

-- assuming a date pattern like: yyyy-mm-dd hh:mm:ss
seconds_to = (date_str) ->
    ok, d = pcall date, date_str
    return nil, err unless ok
    date.diff(d, ngx.time!)\spanseconds!

create_timer = (delay, action, ...) ->
    ok, err = ngx.timer.at delay, action, ...
    unless ok
        ngx.log ngx.ERR, "failed to create timer: ", err

is_locked = ->
    cron = ngx.shared.cron
    cron\get "locked"

is_main = ->
    cron = ngx.shared.cron
    cron\get("locked") == ngx.worker.pid!

set_lock = ->
    cron = ngx.shared.cron
    cron\set "locked", ngx.worker.pid!

tick = (premature) ->
    return if premature

    -- run in new thread to not block current thread
    create_timer 0, ->
        for i, e in ipairs events
            continue unless e\done!
            ok, err = pcall e\run

            unless ok
                e.loop = false
                ngx.log ngx.ERR, "cron: action failed: ", err

            e\update e.time if e.loop
            table.remove events, i unless e.loop

    create_timer 1, tick

class Event
    new: (@time, @loop, @action, ...) =>
        @update time
        @args = { ... }

    done: =>
        true if ngx.time! >= @run_time

    update: (time) =>
        @run_time = ngx.time! + time

    run: =>
        self.action unpack(@args)

cron =
    multi: {}
    day: 24 * 60 * 60
    hour: 60 * 60
    minute: 60

cron.add = (seconds, loop, action, ...) ->
    e = Event seconds, loop, action, ...
    table.insert events, e

cron.multi.every = (seconds, action, ...) ->
    cron.add seconds, true, action, ...

cron.multi.after = (seconds, action, ...) ->
    cron.add seconds, false, action, ...

cron.multi.at = (date, action, ...) ->
    seconds, err = seconds_to date
    return err if err
    cron.add seconds, false, action, ...

cron.every = (seconds, action, ...) ->
    return unless is_main!
    cron.add seconds, true, action, ...

cron.after = (seconds, action, ...) ->
    return unless is_main!
    cron.add seconds, false, action, ...

cron.at = (date, action, ...) ->
    return unless is_main!
    seconds, err = seconds_to date
    return err if err

    cron.add seconds, false, action, ...

cron.start = ->
    res, err = lock "cron", "lock", ->
        return if is_locked!
        set_lock!

    ngx.log, ngx.ERR, "cron: couldn't get lock: ", err if err
    create_timer 1, tick unless err

return cron
