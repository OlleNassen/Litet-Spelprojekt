require("Resources/Scripts/Entity")

Player = {}
Player.__index = Player

function Player:create()
    local this =
    {
		entity = Entity:create(),
		isJumping = false,
		isFalling = false,
		timeSinceJump = 0.0,
    }

	this.entity.x = 50
	this.entity.y = 50
	this.entity.maxSpeed.x = 500
	this.entity.maxSpeed.y = 1000
	this.entity.texture = newTexture("Resources/Sprites/Player/playerDiffuse.png")
	this.entity.normalMap = newTexture("Resources/Sprites/Player/playerNormal.png")
	this.entity.sprite = newSprite(this.entity.normalMap, this.entity.texture)
	spritePos(this.entity.sprite, this.entity.x, this.entity.y)

    setmetatable(this, self)
    return this
end

function Player:moveRight(directionX, deltaTime)
	self.entity:accelerate(directionX, 0, deltaTime)
	return true
end

function Player:moveUp(directionY, deltaTime)
	self.entity:accelerate(0, directionY, deltaTime)
	return true
end

function Player:jump()

	if self.entity.collision_bottom == true then
	self.isJumping = true
	self.isFalling = false
	end

	return false
end

function Player:fly()
	if self.entity.hasGravity == false then
		print("gravityOn")
		self.entity.hasGravity = true	
	else
		print("gravityOff")
		self.entity.hasGravity = false
		self.entity.velocity.y = 0
	end
end

function Player:update(deltaTime)
	
	--Decelerate
	self.entity:decelerate(deltaTime)

	--Final move
	self.entity:move(self.entity.velocity.x * deltaTime, self.entity.velocity.y * deltaTime)

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

function Player:getPosition()
	local position = {x, y}
	position.x = self.entity.x
	position.y = self.entity.y
	return position
end