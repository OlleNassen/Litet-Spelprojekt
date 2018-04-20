require("Resources/Scripts/Entity")

Player = {}
Player.__index = Player

function Player:create()
    local this =
    {
		entity = Entity:create(),
		isJumping = false,
		timeSinceJump = 0.0,
		acceleration = {x = 3500, y = 0},
		deceletation = {x = 1300, y = 0},
		velocity = {x = 0, y = 0},
    }

	this.entity.x = 50
	this.entity.y = 50
	this.entity.speed = 500
	this.entity.texture = newTexture("Resources/Sprites/Player/playerDiffuse.png")
	this.entity.normalMap = newTexture("Resources/Sprites/Player/playerNormal.png")
	this.entity.sprite = newSprite(this.entity.normalMap, this.entity.texture)
	spritePos(this.entity.sprite, this.entity.x, this.entity.y)

    setmetatable(this, self)
    return this
end

function Player:moveRight(direction, deltaTime)

	--Acceleration
	if direction > 0 then
		self.velocity.x = self.velocity.x + (self.acceleration.x * deltaTime)

		if self.velocity.x > self.entity.speed then
			self.velocity.x = self.entity.speed
		end

	elseif direction < 0 then
		self.velocity.x = self.velocity.x - (self.acceleration.x * deltaTime)

		if self.velocity.x < -self.entity.speed then
			self.velocity.x = -self.entity.speed
		end

	end

	return true
end

function Player:jump()
	self.isJumping = true
	return false
end

function Player:update(deltaTime)
	
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
	--Final move
	self.entity:move(self.velocity.x * deltaTime, 0)

	--Jumping
	if self.isJumping then
		
		self.timeSinceJump = self.timeSinceJump + deltaTime
		self.entity:move(0, -500 * deltaTime)
		
		if self.timeSinceJump > 0.5 then
			self.isJumping = false
			self.timeSinceJump = 0.0
		end
	else
		self.entity:update(deltaTime)
	end
end
