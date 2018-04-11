Entity = {}
Entity.__index = Entity

function Entity:create()
    local this =
    {
		x = 0,
		y = 0,
		width = 48,
		height = 48,
		speed = 50,
		attackStrength = 5,
		attackSpeed = 1
    }

    setmetatable(this, self)
    return this
end

function Entity:move(x, y)
	self.x = self.x + x
	self.y = self.y + y
end