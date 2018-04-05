local  = {}
Tile.__index = Tile

setmetatable(Tile, {
  __index = Object, -- this is what makes the inheritance work
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Tile:_init(init1, init2)
  BaseClass._init(self, init1) -- call the base class constructor
  self.value2 = init2
end

function Tile:get_value()
  return self.value + self.value2
end
