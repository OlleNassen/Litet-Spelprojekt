Entity = {}
Entity.__index = Entity

local rectFunc = setSpriteRect
local posFunc = spritePos
local sizeFunc = spriteSize
local min = math.min
local max = math.max

function Entity:create()
    local this =
    {
		texture,
		textureHB,
		normalMap,
		normalHB,
		sprite,
		spriteHB,
		x = 0,
		y = 0,
		collision_width = 48,
		collision_height = 48,
		offsetX = 0,
		offsetY = 0,
		width = 48,
		height = 48,
		world = {},
		maxSpeed = {x = 200, y = 200},
		acceleration = {x = 3500, y = 3500},
		deceletation = {x = 1500, y = 1500},
		velocity = {x = 0, y = 0},
		attackStrength = 5,
		attackSpeed = 1,
		gravityConstant = 400,
		collision_left = false,
		collision_right = false,
		collision_top = false,
		collision_bottom = false,
		hasGravity = true,
		canFly = false,
		hasPowerUp = {},
		health = 100,
		canTakeDamage = true,
		damageTimerStart = false,
		damageTimer = 0.00,
		waitDamageTime = 0.45,
		currentAnimation = 1,
		currentAnimationIndex = 1,
		animationList = {},
		updateAnimationTime = 1.0,
		currentAnimationTime = 0.0,
		spriteWidth = 144,
		spriteHeight = 144,
		isGoingRight = true,
		canMove = true,
    }

	for i=1,2,1 do 
		table.insert(this.hasPowerUp, i, false)
	end

    setmetatable(this, self)
    return this
end

function Entity:setAnimation(animation)
	if self.currentAnimation ~= animation then
		self.currentAnimation = animation
		self.currentAnimationIndex = self.animationList[(animation * 2) - 1]
	end
end

function Entity:update(deltaTime)
	
	local result = self:updateAnimation(deltaTime)

	if self.damageTimerStart == true then
		self.damageTimer = self.damageTimer + deltaTime

		if self.damageTimer >= self.waitDamageTime then
			self:resetCanMove()
		end
	end

	--Gravity
	if self.hasGravity == true then
		self:accelerate(0, 1, deltaTime)
	end

	return result

end

function Entity:resetCanMove()
	self.damageTimer = 0.00
	self.damageTimerStart = false
	self.canTakeDamage = true
	self.canMove = true
end

function Entity:contains(x, y)
	
	local minX = min(self.x, self.x + self.width);
	local maxX = max(self.x, self.x + self.width);
	local minY = min(self.y, self.y + self.height);
	local maxY = max(self.y, self.y + self.height);

	return (x >= minX) and (x < maxX) and (y >= minY) and (y < maxY)
end

function Entity:containsCollisionBox(player)
	
	--[[local minX = min(self.x + self.offsetX, self.x + self.collision_width);
	local maxX = max(self.x + self.offsetX, self.x + self.offsetX + self.collision_width);

	local minY = min(self.y + self.offsetY, self.y + self.collision_height);
	local maxY = max(self.y + self.offsetY, self.y + self.offsetY + self.collision_height);]]

	--[[local minX = self.x + self.offsetX
	local maxX = self.x + self.offsetX + self.collision_width

	local minY = self.y + self.offsetY
	local maxY = self.y + self.offsetY + self.collision_height

	return (x >= minX) and (x <= maxX) and (y >= minY) and (y <= maxY)]]

	--Player Rectancle
	local left = player.entity.x + player.entity.offsetX
	local top = player.entity.y + player.entity.offsetY
	local width = player.entity.collision_width
	local height = player.entity.collision_height

	local r1MinX = min(left, left + width)
	local r1MaxX = max(left, left + width)

	local r1MinY = min(top, top + height)
	local r1MaxY = max(top, top + height)
	--//--

	--Entity Rectancle
	left = self.x + self.offsetX
	top = self.y + self.offsetY
	width = self.collision_width
	height = self.collision_height

	local r2MinX = min(left, left + width)
	local r2MaxX = max(left, left + width)
		  
	local r2MinY = min(top, top + height)
	local r2MaxY = max(top, top + height)
	--//--

	local interLeft = max(r1MinX, r2MinX)
	local interTop = max(r1MinY, r2MinY)
	local interRight = min(r1MaxX, r2MaxX)
	local interBottom = min(r1MaxY, r2MaxY)

	intersection = false

	if (interLeft < interRight) and (interTop < interBottom) then
		intersection = true
	else
		intersection = false
	end

	return intersection
end

function Entity:addWorld(world)
	self.world = world
end

function Entity:addAnimation(startIndex, endIndex)
	table.insert(self.animationList, startIndex)
	table.insert(self.animationList, endIndex)
end

 function Entity:updateAnimation(deltaTime)
	local result = false
	self.currentAnimationTime = self.currentAnimationTime + deltaTime

	if self.currentAnimationTime >= self.updateAnimationTime then
		self.currentAnimationIndex = self.currentAnimationIndex + 1

		self.currentAnimationTime = 0.0
		if self.animationList[1] ~= nil then
			if self.currentAnimationIndex > self.animationList[(self.currentAnimation * 2)] then
				self.currentAnimationIndex = self.animationList[(self.currentAnimation * 2) - 1]
				result = true
			end
		end

		if self.isGoingRight == false then
			rectFunc(self.sprite,self.spriteWidth * (self.currentAnimationIndex - 1), 0, self.spriteWidth * (self.currentAnimationIndex - 1) + self.spriteWidth, self.spriteHeight)
		else
			rectFunc(self.sprite,self.spriteWidth * (self.currentAnimationIndex - 1) + self.spriteWidth, 0,self.spriteWidth * (self.currentAnimationIndex - 1), self.spriteHeight)
		end
	end

	return result
end

function Entity:setPosition(x, y)
	
	--if self.world:canMove(x, y) then
		self.x = x
		self.y = y
	--end
		
	if self.sprite ~= nil then
		posFunc(self.sprite, self.x, self.y)		
	end
end

function Entity:setSize(x, y)
	
	--if self.world:canMove(x, y) then
		self.width = x
		self.height = y
	--end
		
	if self.sprite ~= nil then
		sizeFunc(self.sprite, self.width, self.height)		
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

	elseif directionY < 0 then
		self.velocity.y = self.velocity.y - (self.acceleration.y * deltaTime)

		if self.velocity.y < -self.maxSpeed.y then
			self.velocity.y = -self.maxSpeed.y
		end
	end
	
end

function Entity:decelerate(deltaTime)

	--Deceleration X
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

	--Deceleration Y
	if self.velocity.y < 0 then
		self.velocity.y = self.velocity.y + (self.deceletation.y * deltaTime)
		if self.velocity.y > 0 then
			self.velocity.y = 0
		end
	elseif self.velocity.y > 0 then
		self.velocity.y = self.velocity.y - (self.deceletation.y * deltaTime)
		if self.velocity.y < 0 then
			self.velocity.y = 0
		end
	end

end

function Entity:move(x, y)
	
	self.collision_left = false
	self.collision_right = false
	self.collision_top = false
	self.collision_bottom = false

	if self.world:canMove(self.offsetX + self.x + x, self.offsetY + self.y) and 
	self.world:canMove(self.offsetX + self.x + x + self.collision_width, self.offsetY + self.y + self.collision_height) and 
	self.world:canMove(self.offsetX + self.x + x + self.collision_width, self.offsetY + self.y) and 
	self.world:canMove(self.offsetX + self.x + x, self.offsetY + self.y + self.collision_height) and 
	self.world:canMove(self.offsetX + self.x + x, self.offsetY + self.y) and 
	self.world:canMove(self.offsetX + self.x + x + self.collision_width, self.offsetY + self.y + self.collision_height/2) and
	self.world:canMove(self.offsetX + self.x + x + self.collision_width, self.offsetY + self.y) and 
	self.world:canMove(self.offsetX + self.x + x, self.offsetY + self.y + self.collision_height/2) then
		self.x = self.x + x
	
	else
		if self.velocity.x > 0 then
			self.collision_right = true

		elseif self.velocity.x < 0 then
			self.collision_left = true
		end

		self.velocity.x = 0
	end

	if self.world:canMove(self.offsetX + self.x, self.offsetY + self.y + y) and self.world:canMove(self.offsetX + self.x + self.collision_width, self.offsetY + self.y + y + self.collision_height) and
	self.world:canMove(self.offsetX + self.x + self.collision_width, self.offsetY + self.y + y) and self.world:canMove(self.offsetX + self.x, self.offsetY + self.y + y + self.collision_height) then
		self.y = self.y + y

	else
		if self.velocity.y >= 0 then
			self.collision_bottom = true

		elseif self.velocity.y < 0 then
			self.collision_top = true
		end

		self.velocity.y = 0
	end
		
	if self.sprite ~= nil then
		posFunc(self.sprite, self.x, self.y)
	end

	if self.spriteHB ~= nil then
		posFunc(self.spriteHB, self.x + self.offsetX, self.y + self.offsetY)
	end
end

function Entity:checkHealth()
	if self.health <= 0 then
		self.x = -1000
	end
end	

function Entity:takeDamage(damage, pushBackX, pushBackY, stopMoving)
	if self.canTakeDamage == true then
		self.health = self.health - damage
		self.velocity.x = pushBackX
		self.velocity.y = pushBackY
		self:checkHealth()
		self.damageTimerStart = true
		self.canTakeDamage = false
		stopMoving = stopMoving or false
		if stopMoving == true then
			self.canMove = false
		end
	end

end

function Entity:moveIgnoreWall(x, y)
	self.x = self.x + x
	self.y = self.y + y

	if self.sprite ~= nil then
		posFunc(self.sprite, self.x, self.y)		
	end
end
