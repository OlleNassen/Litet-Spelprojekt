require("Resources/Scripts/Entity")

Player = {}
Player.__index = Player

function Player:create()
    local this =
    {
		entity = Entity:create(),
		isJumping = false,
		isFalling = false,
		jumpPower = -1300,
		maxNrOfJumps = 1,
		nrOfJumps = 1,
		dashing = false,
		canDash = true,
		timeSinceDamage = 0.0,
		textureHPBarBack = newTexture("Resources/Sprites/Player/hpbarback.png"),
		textureHPBar = newTexture("Resources/Sprites/Player/hpbar.png"),
		spriteHPBarBack,
		spriteHPBar,
		standardAnimationTime = 0.05
    }
	
	this.entity.x = 50
	this.entity.y = 16 * 48
	this.entity.collision_width = 48
	this.entity.collision_height = 72
	this.entity.offsetX = 24
	this.entity.offsetY = 48
	this.entity.width = 120
	this.entity.height = 120
	this.entity.maxSpeed.x = 500
	this.entity.maxSpeed.y = 1000
	this.entity.hasGravity = true
	this.entity.canFly = false
	this.entity.texture = newTexture("Resources/Sprites/Player/player_sprite.png")
	this.entity.textureHB = newTexture("Resources/Sprites/hitbox.png")
	this.entity.spriteWidth = 144
	this.entity.spriteHeight = 144
	this.entity:addAnimation(1,1) -- Idle = 1
	this.entity:addAnimation(16, 28) -- Run = 2
	this.entity:addAnimation(10, 10) -- Hurt = 3
	this.entity:addAnimation(11, 11) -- Jump up = 4
	this.entity:addAnimation(12, 12) -- Jump in air = 5
	this.entity:addAnimation(13, 13) -- Fall = 6
	this.entity:addAnimation(2,4) -- Attack = 7
	this.entity:setAnimation(2)
	this.entity.updateAnimationTime = 0.05
	this.entity.normalMap = newTexture("Resources/Sprites/Player/player_normals.png")
	this.entity.normalHB = newTexture("Resources/Sprites/hitbox_normal.png")
	this.entity.sprite = newSprite(this.entity.width, this.entity.height, this.entity.normalMap, this.entity.texture)
	spritePos(this.entity.sprite, this.entity.x, this.entity.y)
	setSpriteRect(this.entity.sprite,0,0,86,95)

	this.entity.spriteHB = newSprite(this.entity.collision_width, this.entity.collision_height, this.entity.normalHB, this.entity.textureHB)
	spritePos(this.entity.spriteHB, this.entity.x + this.entity.offsetX, this.entity.y + this.entity.offsetY)

    setmetatable(this, self)
    return this
end

function Player:moveRight(directionX, deltaTime)
	self.entity:accelerate(directionX, 0, deltaTime)
	self.entity:setAnimation(2)
	if directionX > 0 then
		self.entity.isGoingRight = true
	else
		self.entity.isGoingRight = false
	end

	return true
end

function Player:moveUp(directionY, deltaTime)
	if self.entity.canFly == true then
		self.entity:accelerate(0, directionY, deltaTime)
	end
	return true
end

function Player:jump()

	if self.nrOfJumps > 0 then
		 self.entity.velocity.y = self.jumpPower
		 self.nrOfJumps = self.nrOfJumps - 1
		 self.isJumping = true
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
	if self.entity.collision_bottom == true then
		self.nrOfJumps = self.maxNrOfJumps 
		
		if self.entity.velocity.x == 0 then
			self.entity:setAnimation(1)
		end
	end

	if self.isJumping == true then
		self.entity:setAnimation(4)
		if self.entity.velocity.y > -300 then
			self.isJumping = false
			self.entity:setAnimation(5)
		end
	end

	if self.entity.velocity.y > 300 then
		self.entity:setAnimation(6)
	end



	self.entity:update(deltaTime)

	--Hp bar
	self:updateHPBar()
	
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

		self.entity:setAnimation(3)

	end
end