local Object = {}
object.__index = BaseClass

setmetatable(Object, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Object:_init(init)
  self.value = init
end

function Object:set_value(newval)
  self.value = newval
end

function Object:get_value()
  return self.value
end