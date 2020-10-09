local ngx = ngx

local json = require 'cjson.safe'
local utils = require 'set.utils'

local Token = {}

function Token.hash(secret, data, expire)
  return utils.sha1(('%s%s%d'):format(secret, data, expire))
end

function Token:decode(secret, token)
  local data, expire, hash = token:match('^([=/%+%w]+):([%d]+):([%x]+)$')
  if not hash or self.hash(secret, data, expire) ~= hash then
    return nil, 'token_invalid'
  end
  if tonumber(expire) < ngx.now() then
    return nil, 'token_expired'
  end
  return json.decode(utils.atob(data))
end

function Token:encode(secret, data, expire)
  data = utils.btoa(json.encode(data))
  local token = self.hash(secret, data, expire)
  return ('%s:%d:%s'):format(data, expire, token)
end

return Token