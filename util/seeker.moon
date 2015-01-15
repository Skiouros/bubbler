json = require "cjson"
http = require "resty.http"

http_version = 1.1
max_redirects = 5

merge_tables = (src, dest) ->
    dest[k] = v for k, v in pairs src
    dest

join_urls = (...) ->
    paths = { ... }
    path = table.remove paths, 1

    for loc in *paths
        left = string.sub(path, #path) == "/"
        right = string.sub(loc, 1, 1) == "/"

        -- remove / from beggining of loc
        if right and left then loc = string.sub(loc, 2, #loc)
        if not right and not left then loc = "/#{loc}"
        path ..= loc
    path

local seeker
class Session
    headers: {}
    new: (@uri) =>

    get: (uri, args) => @request "GET", uri, args
    put: (uri, args) => @request "PUT", uri, args
    post: (uri, args) => @request "POST", uri, args
    head: (uri, args) => @request "HEAD", uri, args
    delete: (uri, args) => @request "DELETE", uri, args

    request: (method, uri, args) =>
        uri = join_urls @uri, uri if @uri

        -- allows sessions to have global headers
        args.headers = merge_tables args.headers or {}, @headers
        seeker.request method, uri, args

class Response
    history: {}

    new: (@req, @res) =>
        for attr in *{ "status", "headers", "has_body" }
            @[attr] = @res[attr]

        @body = @res\read_body! if @has_body
        @req.conn\close!

    json: =>
        ok, res = pcall -> json.decode @body
        return nil, res unless ok
        res

class Request
    new: (uri) =>
        @conn = http\new!
        @scheme, @host, @port, @path = unpack(@conn\parse_uri uri)

    -- ssl cert not checked currently
    handle_ssl: =>
        return unless @port == 443
        session, err = @conn\ssl_handshake!
        err

    connect: =>
        ok, err = @conn\connect @host, @port
        return err unless ok
        @handle_ssl!

    set_auth: (auth) =>
        auth = "#{auth[1]}:#{auth[2]}"
        @headers.Authorization = "Basic #{ngx.encode_base64 auth}"

    encode_data: (data) =>
        @body = ngx.encode_args data
        @headers["Content-Type"] = "application/x-www-form-urlencoded"

    encode_json: (data) =>
        @body = json.encode data
        @headers["Content-Type"] = "application/json"

    to_params: (args) =>
        {
            body: @body
            path: @path
            headers: @headers
            method: args.method
            versoin: args.version
        }

    get: (args) =>
        @headers = args.headers or {}
        @body = args.body

        @path = "/" if @path == ""
        @path ..= "?" .. ngx.encode_args args.params if args.params

        if err = @connect!
            return nil, err

        @encode_json args.json if args.json
        @encode_data args.data if args.data
        @set_auth args.auth if args.auth

        res, err = @conn\request @to_params args
        return nil, err if err or res == ngx.null
        Response @, res

seeker = {}
seeker.session = (uri) ->
    Session uri

seeker.get = (uri, args) -> seeker.request "GET", uri, args
seeker.put = (uri, args) -> seeker.request "PUT", uri, args
seeker.post = (uri, args) -> seeker.request "POST", uri, args
seeker.head = (uri, args) -> seeker.request "HEAD", uri, args
seeker.delete = (uri, args) -> seeker.request "DELETE", uri, args
seeker.request = (method, uri, args) ->
    args = {} unless args
    args.method = method
    args.version = args.http_version or http_version

    req = Request uri
    res, err = req\get args

    return nil, err if err

    -- follow up to n redirects
    if args.redirect and res.status == 301
        n = 0
        while res.status == 301 and n < max_redirects
            response, err = seeker.request method, res.headers.location, args
            return nil, err if err
            table.insert response.history, res
            res = response
            n += 1
        return nil, "redirect loop" if n > max_redirects

    res

return seeker
