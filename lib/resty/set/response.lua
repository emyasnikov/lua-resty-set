local ngx = ngx

local json = require 'cjson.safe'

local Response = {}

function Response.error(status, text)
  ngx.header.content_type = 'text/plain'
  ngx.log(ngx.ERR, text)
  ngx.status = status
  ngx.print(text)
  ngx.exit(status)
end

function Response.exit(status)
  ngx.exit(status)
end

function Response.header(header, value)
  ngx.header[header] = value
end

function Response.json(data)
  ngx.header.content_type = 'application/json'
  data = json.encode(data)
  ngx.print(data)
  return data
end

return Response