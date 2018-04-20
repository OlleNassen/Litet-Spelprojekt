Entity = {}
Entity.__index = Entity

function Entity:create()
    local this =
    {
		texture,
		normalMap,
		sprite,
		x = 0,
		y = 0,
		width = 48,
		height = 48,
		world = {},
		speed = 200,
		acceleration = {x = 3500, y = 0},
		deceletation = {x = 1300, y = 0},
		velocity = {x = 0, y = 0},
		attackStrength = 5,
		attackSpeed = 1,
		gravityConstant = 400,
		collisionX = false,
    }

    setmetatable(this, self)
    return this
end

function Entity:update(deltaTime)
	
	--Gravity
	self:move(0, self.gravityConstant * deltaTime)

end

function Entity:contains(x, y)
	
	minX = math.min(self.x, self.x + self.width);
	maxX = math.max(self.x, self.x + self.width);
	minY = math.min(self.y, self.y + self.height);
	maxY = math.max(self.y, self.y + self.height);

	return (x >= minX) and (x < maxX) and (y >= minY) and (y < maxY)
end

function Entity:addWorld(world)
	self.world = world
end

function Entity:setPosition(x, y)
	
	--if self.world:canMove(x, y) then
		self.x = x
		self.y = y
	--end
		
	if self.sprite ~= nil then
		spritePos(self.sprite, self.x, self.y)		
	end
end

function Entity:getPosition()
	local position = {x, y}
	position.x = self.x
	position.y = self.y
	return position
end

function Entity:accelerate(direction, deltaTime)

		--Acceleration
	if direction > 0 then
		self.velocity.x = self.velocity.x + (self.acceleration.x * deltaTime)

		if self.velocity.x > self.speed then
			self.velocity.x = self.speed
		end

	elseif direction < 0 then
		self.velocity.x = self.velocity.x - (self.acceleration.x * deltaTime)

		if self.velocity.x < -self.speed then
			self.velocity.x = -self.speed
		end
	end
	
end

function Entity:decelerate(deltaTime)

	--Deceleration
	if self.velocity.x < 0 then
		self.velocity.x = self.velocity.x + (self.deceletation.x * deltaTime)
		if self.velocity.x > 0 then
			self.velocity.x = 0
		end
	elseif self.velocity.x > 0 then
		self.velocity.x = self.velocity.x - (self.deceletation.x * deltaTime)
		if self.velocity.x < 0 then
			self.velocity.x = 0
		end
	end

end

function Entity:move(x, y)
	
	if self.world:canMove(self.x + x, self.y) and self.world:canMove(self.x + x + self.width, self.y + self.height) and 
	self.world:canMove(self.x + x + self.width, self.y) and self.world:canMove(self.x + x, self.y + self.height) then
		self.x = self.x + x
		self.collisionX = false
	else
		self.collisionX = true
		self.velocity.x = 0
	end

	if self.world:canMove(self.x, self.y + y) and self.world:canMove(self.x + self.width, self.y + y + self.height) and
	self.world:canMove(self.x + self.width, self.y + y) and self.world:canMove(self.x, self.y + y + self.height) then
		self.y = self.y + y
	end
		
	if self.sprite ~= nil then
		spritePos(self.sprite, self.x, self.y)		
	end
end

function Entity:moveIgnoreWall(x, y)
	self.x = self.x + x
	self.y = self.y + y

	if self.sprite ~= nil then
		spritePos(self.sprite, self.x, self.y)		
	end
end