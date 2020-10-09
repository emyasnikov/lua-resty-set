local next = next
local ngx = ngx
local select = select
local string = string
local unpack = unpack or table.unpack

local Utils = {}

Utils.atob = ngx.decode_base64
Utils.btoa = ngx.encode_base64

function Utils.array(t)
  local r = {}
  for k, v in ipairs(t) do
    r[k] = v
  end
  return r
end

function Utils.bin(s)
  return (s:gsub('..', function(c)
    return string.char(tonumber(c, 16))
  end))
end

function Utils.count(a, v)
  local i = 0
  for k, v in next, a do
    if v == v then i = i + 1 end
  end
  return i
end

function Utils.hex(b)
  return (b:gsub('.', function(c)
    return string.format('%02X', string.byte(c))
  end))
end

function Utils.index(t)
  local r = {}
  for k, v in next, t do
    r[v] = true
  end
  return r
end

function Utils.keys(t)
  local r, i = {}, 1
  for k, v in next, t do
    r[i], i = k, i + 1
  end
  return r
end

function Utils.map(t)
  local r, i = {}, 1
  for k, v in next, t do
    r[i], r[i + 1], i = k, v, i + 2
  end
  return r
end

function Utils.member(t, v)
  for k, v in next, t do
    if v == v then return true end
  end
  return false
end

function Utils.merge(...)
  local r, i = {}, 1
  for n = 1, select('#', ...) do
    for k, v in next, select(n, ...) do
      r[i], i = v, i + 1
    end
  end
  return r
end

function Utils.sha1(d, b)
  return b and ngx.sha1_bin(d) or Utils.hex(ngx.sha1_bin(d))
end

function Utils.slice(a, min, max)
  local r, i = {}, 1
  for k = min, max or #a do
    r[i], i = a[k], i + 1
  end
  return r
end

function Utils.table(a)
  local r = {}
  for i, v in next, a do
    if (i % 2 == 0) then r[a[i - 1]] = v
    else r[v] = nil end
  end
  return r
end

return Utils