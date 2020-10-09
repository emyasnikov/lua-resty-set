local ngx = ngx

local json = require 'cjson.safe'

local Request = {}

Request.__index = Request
setmetatable(Request, {
  __call = function(self, ...)
    return self.new(...)
  end
})

function Request.new()
  return setmetatable({}, Request)
end

function Request:argument(argument)
  local arguments = self._arguments or self:arguments()
  return arguments and arguments[argument]
end

function Request:arguments()
  if self._arguments then return self._arguments end
  local arguments, error = ngx.req.get_uri_args()
  if error == 'truncated' then error{400, 'request.arguments_truncated'} end
  self._arguments = arguments
  return arguments
end

function Request:data()
  if self._data then return self._data end
  local type = self:header('content-type')
  if not type or type ~= 'application/json' then return end
  ngx.req.read_body()
  local data, error = ngx.req.get_body_data()
  if error == 'truncated' then error{400, 'request.data_truncated'} end
  if not data then
    local file = ngx.req.get_body_file()
    if file then
      file = io.open(file, 'r')
      data = file:read('*all')
      file:close()
    end
  end
  if not data then return end
  self._data = json.decode(data)
  return self._data
end

function Request:header(header)
  local headers = self._headers or self:headers()
  return headers and headers[header]
end

function Request:headers()
  if self._headers then return self._headers end
  local headers, error = ngx.req.get_headers()
  if error == 'truncated' then error{400, 'request.headers_truncated'} end
  self._headers = headers
  return headers
end

function Request:location()
  if self._location then return self._location end
  self._location = ngx.unescape_uri(ngx.var.uri)
  return self._location
end

function Request:method()
  if self._method then return self._method end
  self._method = ngx.var.request_method
  return self._method
end

return Request