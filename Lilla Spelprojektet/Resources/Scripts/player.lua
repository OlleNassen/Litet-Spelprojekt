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
		jumpPower = -1300,
		dashing = false,
		canDash = true,
		timeSinceDamage = 0.0,
		textureHPBarBack = newTexture("Resources/Sprites/Player/hpbarback.png"),
		textureHPBar = newTexture("Resources/Sprites/Player/hpbar.png"),
		spriteHPBarBack,
		spriteHPBar,
    }
	
	this.entity.x = 50
	this.entity.y = 50
	this.entity.width = 45
	this.entity.height = 60
	this.entity.maxSpeed.x = 500
	this.entity.maxSpeed.y = 1000
	this.entity.hasGravity = true
	this.entity.canFly = false
	this.entity.texture = newTexture("Resources/Sprites/Player/playerDiffuse.png")
	this.entity.normalMap = newTexture("Resources/Sprites/Player/playerNormal.png")
	this.entity.sprite = newSprite(this.entity.width, this.entity.height, this.entity.normalMap, this.entity.texture)
	spritePos(this.entity.sprite, this.entity.x, this.entity.y)
	setSpriteRect(this.entity.sprite,0,0,86,95)



    setmetatable(this, self)
    return this
end

function Player:moveRight(directionX, deltaTime)
	self.entity:accelerate(directionX, 0, deltaTime)
	return true
end

function Player:moveUp(directionY, deltaTime)
	if self.entity.canFly == true then
		self.entity:accelerate(0, directionY, deltaTime)
	end
	return true
end

function Player:jump()

	if self.entity.collision_bottom == true then
		 self.entity.velocity.y = self.jumpPower
	end

	return false
end

function Player:fly()
	if self.entity.canFly == false then
		print("fly_ON")
		self.entity.canFly = true
		self.entity.hasGravity = false
	else
		print("fly_OFF")
		self.entity.canFly = false
		self.entity.hasGravity = true
		self.entity.velocity.y = 0
	end
end

function Player:updateHPBar()
	spriteSize(self.spriteHPBar, (self.entity.health/100)*500, 50)
end

function Player:update(deltaTime)
	
	self.timeSinceDamage = self.timeSinceDamage + deltaTime
	
	if self.entity.health <= 0 then
		push("Resources/Scripts/LuaStates/gameOverState.lua")
	end

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

	--Hp bar
	self:updateHPBar()
	spritePos(self.spriteHPBarBack, self.entity.x-590, self.entity.y-310)
	spritePos(self.spriteHPBar, self.entity.x-590, self.entity.y-310)
end

function Player:getPosition()
	local position = {x, y}
	position.x = self.entity.x
	position.y = self.entity.y
	return position
end

function Player:takeDamage(dmg)
	if self.timeSinceDamage > 1.0 then
		self.entity.health = self.entity.health - dmg
		self.timeSinceDamage = 0.0
		self.entity.velocity.y = -1000
		print "AJ!!!"
	end
end