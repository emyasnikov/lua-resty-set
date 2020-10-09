local next = next
local table = table

local response = require 'set.response'
local utils = require 'set.utils'

local Route = {}

function Route:match(method, location, callback)
  if self._routes then
    for path, handlers in next, self._routes do repeat
      local variables = {location:find(path)}
      if #variables == 0 then break end
      if method == 'OPTIONS' then
        response.header('Allow', table.concat(utils.keys(handlers), ', '))
        response.exit(204)
      end
      variables = utils.slice(variables, 3)
      if handlers[method] then
        return callback(self, handlers[method], variables)
      end
      return response.error(405, 'route.method.not_allowed')
    until true end
  end
  return response.error(404, 'route.not_found')
end

function Route:route(method, path, handler)
  self._routes = self._routes or {}
  path = ('^/?%s/?$'):format(path)
  local routes = self._routes[path] or {}
  routes[method:upper()] = handler
  self._routes[path] = routes
end

return Route