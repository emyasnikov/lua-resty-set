local example = require 'set'

-- Request event can be used to connect to database or validate token.
example:on('request', function(self)
  -- Self variable contains data, location, method, and query arguments.
  if self.location == '/example' then
    -- There are also database, request, and response tables inside.
    self.db = self.database('example')
  end
end)

-- Create function is a shortcut for POST with data.
example:create('example', function(self)
  -- Placeholders with colon in front will be wrapped using backticks.
  local result = self.db:query([[
    INSERT INTO :example (
      :key, `value`
    ) VALUES (
      {{key}}, "%s"
    )
  ]], {
    -- Named placeholder will be replaced and wrapped in double quotes.
    key = self.data.key,
    -- All other placeholder will be used in the format function,
    -- in this case to replace "%s".
    self.data.value
  })
  -- The error function takes table with HTTP status code and text.
  if not result then error{500, 'example.not_created'} end
  -- Returned result will be printed in JSON format.
  return {created = result.affected_rows}
end)

-- Read function is a shortcut for GET with ID inside path, like "/example/1".
example:read('example', function(self, id)
  local result = self.db:query([[
    SELECT *
    FROM :example
    WHERE :id = %d
  ]], {id})
  if not result then error{500, 'example.not_available'}
  elseif #result == 0 then error{404, 'example.not_found'} end
  return result[next(result)]
end)

-- Update function is a shortcut for PATCH with ID and data.
example:update('example', function(self, id)
  local result = self.db:query([[
    UPDATE :example
    SET :value = {{value}}
    WHERE :id = %d
  ]], {
    id,
    value = self.data.value
  })
  if not result then error{500, 'example.not_changed'}
  elseif result.affected_rows < 1 then error{404, 'example.not_found'} end
  return {changed = result.affected_rows}
end)

-- Delete function is a shortcut for DELETE with ID.
example:delete('example', function(self, id)
  local result = self.db:query([[
    DELETE FROM :example WHERE :id = %d
  ]], {id})
  if not result then error{500, 'example.not_deleted'}
  elseif result.affected_rows < 1 then error{404, 'example.not_found'} end
  return {deleted = result.affected_rows}
end)

example:route('GET', '/examples', function(self)
  local result = self.db:query([[
    SELECT *
    FROM :example
  ]])
  if not result then error{500, 'example.internal_error'} end
  return result
end)

-- Response event is a good place to close database connection.
example:on('response', function(self, result)
  if self.db then
    self.db:keepalive()
  end
end)

example:init()