# lua-resty-set

**lua-resty-set** is a library for OpenResty supporting route matching, events, tokens, and some handy database query operations.

## CRUD

**lua-resty-set** supports predefined CRUD endpoints, which can be used to shorted code.

### Create

```lua
example:create('example', function(self) end)
```

This matches `POST /example` and reads data to `self.data`.

### Read

```lua
example:read('example', function(self, id) end)
```

This matches `GET /example/1`.

### Update

```lua
example:update('example', function(self, id) end)
```

This matches `PATCH /example/1` and reads data to `self.data`.

### Delete

```lua
example:delete('example', function(self, id) end)
```

And this matches `DELETE /example/1`.

## Routes

```lua
example:route('GET', '/example/(%d+)', function(self, id) end)
```

Route function takes method and path with variables in it, like the numerical ID in this case.

## See Also

[lua-resty-route](https://github.com/bungle/lua-resty-route) — Routing library which was inspiration for this project

## Licence

Copyright (c) 2019 - 2020, Evgenij Myasnikov
All rights reserved.