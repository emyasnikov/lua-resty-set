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

**lua-resty-set** uses MIT License.

```
Copyright (c) 2019 - 2020, Evgenij Myasnikov
All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```