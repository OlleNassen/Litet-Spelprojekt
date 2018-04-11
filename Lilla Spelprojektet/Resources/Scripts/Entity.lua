Entity = {}
Entity.__index = Entity

function Entity:create()
    local this =
    {
		x = 0,
		y = 0,
		width = 48,
		height = 48,
		world = {},
		speed = 50,
		attackStrength = 5,
		attackSpeed = 1
    }

    setmetatable(this, self)
    return this
end

function Entity:addWorld(world)
	self.world = world
end

function Entity:move(x, y)
	
	if self.world:canMove(self.x + x, self.y) and self.world:canMove(self.x + x + self.width, self.y + self.height) and 
	self.world:canMove(self.x + x + self.width, self.y) and self.world:canMove(self.x + x, self.y + self.height) then
		self.x = self.x + x
	end

	if self.world:canMove(self.x, self.y + y) and self.world:canMove(self.x + self.width, self.y + y + self.height) and
	self.world:canMove(self.x + self.width, self.y + y) and self.world:canMove(self.x, self.y + y + self.height) then
		self.y = self.y + y
	end

end