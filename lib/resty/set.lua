local database = require 'set.database'
local event = require 'set.event'
local request = require 'set.request'
local response = require 'set.response'
local route = require 'set.route'

local Set = setmetatable({}, {
  __index = function(self, key)
    for _, i in next, {event, route} do
      if i[key] then
        self[key] = i[key]
        return i[key]
      end
    end
  end
})

function Set.call(callback, ...)
  local status, result = pcall(callback, ...)
  if not status then return response.error(
    result.code or result[1] or 500,
    result.text or result[2] or 'server.internal_error'
  ) end
  return result or status
end

function Set:create(route, handler)
  self:route('POST', ('/%s'):format(route), function(self)
    if not self.data then error{400, 'http.bad_request'} end
    return handler(self)
  end)
end

function Set:delete(route, handler)
  self:route('DELETE', ('/%s/(%%d)'):format(route), handler)
end

function Set:init()
  local set = {
    database = database,
    request = request(),
    response = response
  }
  set.data = set.request:data()
  set.location = set.request:location()
  set.method = set.request:method()
  set.query = set.request:arguments()
  assert(self.call(self.trigger, self, 'request', set))
  self:match(set.method, set.location, function(self, handler, variables)
    local result = self.call(handler, set, unpack(variables))
    assert(self.call(self.trigger, self, 'response', set, result))
    return response.json(result)
  end)
end

function Set:load(modules)
  for _, module in next, modules do require(module) end
end

function Set:read(route, handler)
  self:route('GET', ('/%s/(%%d)'):format(route), handler)
end

function Set:update(route, handler)
  self:route('PATCH', ('/%s/(%%d)'):format(route), function(self, id)
    if not self.data then error{400, 'http.bad_request'} end
    return handler(self, id)
  end)
end

return Set