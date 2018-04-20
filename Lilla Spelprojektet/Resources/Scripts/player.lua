require("Resources/Scripts/Entity")

Player = {}
Player.__index = Player

function Player:create()
    local this =
    {
		entity = Entity:create(),
		isJumping = false,
		timeSinceJump = 0.0,
    }

	this.entity.x = 50
	this.entity.y = 50
	this.entity.speed = 200
	this.entity.texture = newTexture("Resources/Sprites/Player/playerDiffuse.png")
	this.entity.normalMap = newTexture("Resources/Sprites/Player/playerNormal.png")
	this.entity.sprite = newSprite(this.entity.normalMap, this.entity.texture)
	spritePos(this.entity.sprite, this.entity.x, this.entity.y)

    setmetatable(this, self)
    return this
end

function Player:moveRight(direction, deltaTime)
	self.entity:move(direction * self.entity.speed * deltaTime, 0)
	return true
end

function Player:jump()
	self.isJumping = true
	return false
end

function Player:update(deltaTime)
	
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