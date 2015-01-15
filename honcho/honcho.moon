Queue = require "honcho.queue"
json = require "cjson"

args_equal = (a, b) ->
    for i, v in pairs a
        unless b[i] == v
            return false
    return true

-- TODO: use msgpck for encoding
-- TODO: change strucute, KISS
-- TODO: write scheduler

-- honcho:queues <- set of all queues
-- honcho:queue:{queue} <- list of tasks in queue
-- honcho:queues:failed <- list of all failed tasks
-- honcho:workers:{worker-id} <- keys using schema, would use list
--                               but no support for timeout
--                               could implement with polling
-- honcho:stat:failed <- total # of failed tasks
-- honcho:stat:processed <- total # of processed tasks

class Honcho
    namespace: "honcho"
    queues: {}

    new: (@redis) =>

    serialize: (klass, ...) =>
        json.encode args: {...}, class: klass.__name

    verify: (klass) =>
        unless klass.queue
            error "class '#{klass.__name}' missing queue attribute"
        unless klass.preform
            error "class '#{klass.__name}' missing preform method"

    get_queues: =>
        @redis\smembers "#{@namespace}:queues"

    queue: (name) =>
        if not @queues[name] or @queues[name].destroyed
            @queues[name] = Queue @namespace, name, @redis

        -- queue needs to have redis updated
        -- to prevent race conditions :(
        -- https://github.com/openresty/lua-resty-redis#limitations
        @queues[name].redis = @redis
        return @queues[name]

    enqueue: (klass, ...) =>
        @verify klass
        @push klass.queue, @serialize klass, ...

    -- removes all jobs of klass
    -- optional: specify args to limit serach
    dequeue: (klass, ...) =>
        @verify klass
        @destroy klass.queue, klass.__name, ...

    -- remove all queues from queue with klass name and args
    destroy: (queue, klass, ...) =>
        info = @process_queue queue, klass, ...
        @redis\del info.tmp
        #info.results

    queued: (klass, ...) =>
        info = @process_queue klass.queue, klass.__name, ...
        [@redis\rpoplpush info.tmp, info.queue for i = 1, #info.results]
        info.results

    remove_queue: (name) =>
        @queue(name)\destroy!

    pop: (name) =>
        res, err = @queue(name)\pop @redis
        if not err and res != ngx.null
            res = json.decode res
        res, err

    push: (name, ...) =>
        @queue(name)\push ...

    peek: (name, start = 0, len = 1) =>
        @queue(name)\slice start, len

    size: (name) =>
        @queue(name)\size!

    failed_job: (info) =>
        @redis\rpush "#{@namespace}:queues:failed", json.encode info
        @redis\incr "#{@namespace}:stat:failed"

    process_queue: (queue, klass, ...) =>
        args = { ... }
        results = {}

        -- keep connectin open
        autoclose = @redis.autoclose
        @redis.autoclose = ""

        queue = @queue(queue)
        processing_queue = "#{queue.key_name}:temp:#{os.time!}"
        tmp_queue = "#{processing_queue}:#{@namespace}"

        while true
            str = queue\rpoplpush processing_queue
            break if str == ngx.null

            obj = json.decode str
            if obj.class = klass and (#args == 0 or args_equal args, obj.args)
                table.insert results, 1, obj
            else
                @redis\rpoplpush processing_queue, tmp_queue

        -- push all keys back to original queue
        while @redis\rpoplpush(tmp_queue, queue.key_name) != ngx.null do ""
        @redis.autoclose = autoclose
        @redis\done!

        tmp: processing_queue, queue: queue.key_name, :results
