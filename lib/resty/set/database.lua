local ngx = ngx
local unpack = unpack or table.unpack

local mysql = require 'resty.mysql'
local utils = require 'set.utils'

local Database = {}

Database.__index = Database
setmetatable(Database, {
  __call = function(self, ...)
    return self.new(...)
  end
})

function Database.new(options)
  options = options or {}
  if type(options) == 'string' then
    options = {database = options}
  end
  local self = setmetatable({}, Database)
  local database = mysql:new()
  if not database then error{500, 'database.not_available'} end
  if not options.database then error{500, 'database.not_configured'} end
  database:set_timeout(options.timeout or 1000)
  local status = database:connect{
    host = options.host or '127.0.0.1',
    port = options.port or 3306,
    database = options.database,
    user = options.user or 'root',
    password = options.password or '',
    charset = options.charset or 'utf8',
    max_packet_size = options.max_packet_size or 1024 * 1024,
  }
  if not status then error{500, 'database.connection_failed'} end
  self.database = database
  self._keepalive = options.keepalive or 1000
  self._pool = options.pool or 100
  self._prefix = options.prefix or ''
  return self
end

function Database:close()
  local status = self.database:close()
  if not status then
    ngx.log(ngx.ERR, 'database.close_failed')
  end
  return status
end

function Database:keepalive(keepalive, pool)
  local status = self.database:set_keepalive(keepalive or self._keepalive, pool or self._pool)
  if not status then
    ngx.log(ngx.ERR, 'database.keepalive_failed')
  end
  return status
end

function Database:query(query, values)
  if values then
    query = query:gsub('({{[_%w]+}})', function(placeholder)
      local value = values[placeholder:sub(3, -3)] or values[placeholder]
      if not value then return 'NULL' end
      return ('"%s"'):format(value)
    end)
    values = utils.array(values)
    if #values > 0 then
      query = query:format(unpack(values))
    end
  end
  query = query:gsub('(:[_%w]+)', function(placeholder)
    return ('`%s`'):format(placeholder:sub(2, -1))
  end)
  return self.database:query(query)
end

return Database