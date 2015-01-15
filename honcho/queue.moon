class Queue

    new: (@namespace, @name, @redis) =>
        @key_name = "#{@namespace}:queue:#{@name}"
        @redis\sadd "#{@namespace}:queues", @name

    pop: =>
        @redis\lpop @key_name

    rpoplpush: (dest) =>
        @redis\rpoplpush @key_name, dest

    push: (...) =>
        @redis\rpush @key_name, ...

    peek: =>
        @slice 0, 1

    slice: (start, len) =>
        @redis\lrange @key_name, start, start + len-1

    size: =>
        @redis\llen @key_name

    destroy: =>
        @redis\pipeline ->
            @redis\del @key_name
            @redis\srem "#{@namespace}:queues", @name

        @destroyed = true
