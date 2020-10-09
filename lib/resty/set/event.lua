local Event = {}

function Event:on(event, handler)
  self._events = self._events or {}
  local events = self._events[event] or {}
  events[#events + 1] = handler
  self._events[event] = events
end

function Event:trigger(event, ...)
  if self._events and self._events[event] then
    for i = 1, #self._events[event] do
      self._events[event][i](...)
    end
  end
end

return Event
