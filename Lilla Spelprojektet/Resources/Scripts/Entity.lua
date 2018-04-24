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
		maxSpeed = {x = 200, y = 200},
		acceleration = {x = 3500, y = 1200},
		deceletation = {x = 1300, y = 0},
		velocity = {x = 0, y = 0},
		attackStrength = 5,
		attackSpeed = 1,
		gravityConstant = 400,
		collision_left = false,
		collision_right = false,
		collision_top = false,
		collision_bottom = false,
		hasPowerUp = {},
		hasGravity = true,
	}

	for i=1,2,1 do 
		table.insert(this.hasPowerUp, i, false)
	end

    setmetatable(this, self)
    return this
end

function Entity:update(deltaTime)
	
	--Gravity
	if self.hasGravity == true then
		self:accelerate(0, 1, deltaTime)
	end
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

function Entity:accelerate(directionX, directionY, deltaTime)

	--Acceleration
	if directionX > 0 then -- Right
		self.velocity.x = self.velocity.x + (self.acceleration.x * deltaTime)

		if self.velocity.x > self.maxSpeed.x then
			self.velocity.x = self.maxSpeed.x
		end

	elseif directionX < 0 then -- Left
		self.velocity.x = self.velocity.x - (self.acceleration.x * deltaTime)

		if self.velocity.x < -self.maxSpeed.x then
			self.velocity.x = -self.maxSpeed.x
		end
	end

	if directionY > 0 then
		self.velocity.y = self.velocity.y + (self.acceleration.y * deltaTime)

		if self.velocity.y > self.maxSpeed.y then
			self.velocity.y = self.maxSpeed.y
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
	
	self.collision_left = false
	self.collision_right = false
	self.collision_top = false
	self.collision_bottom = false

	if self.world:canMove(self.x + x, self.y) and self.world:canMove(self.x + x + self.width, self.y + self.height) and 
	self.world:canMove(self.x + x + self.width, self.y) and self.world:canMove(self.x + x, self.y + self.height) then
		self.x = self.x + x
	
	else
		if self.velocity.x > 0 then
			self.collision_right = true

		elseif self.velocity.x < 0 then
			self.collision_left = true
		end

		self.velocity.x = 0
	end

	if self.world:canMove(self.x, self.y + y) and self.world:canMove(self.x + self.width, self.y + y + self.height) and
	self.world:canMove(self.x + self.width, self.y + y) and self.world:canMove(self.x, self.y + y + self.height) then
		self.y = self.y + y

	else
		if self.velocity.y > 0 then
			self.collision_bottom = true

		elseif self.velocity.y < 0 then
			self.collision_top = true

		end

		self.velocity.y = 0
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