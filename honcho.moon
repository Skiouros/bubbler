Redis = require "util.redis"
Honcho = require "honcho.honcho"
config = require("lapis.config").get!

return Honcho with Redis config.redis.host, config.redis.port
    .autoclose = "keepalive"
    \keepalive 10 * 1000, 3
