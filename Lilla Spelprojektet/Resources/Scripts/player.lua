
local walkBuffer = newSoundBuffer("Resources/Sound/walk.wav")
local walkSound = newSound(walkBuffer)

local jumpBuffer = newSoundBuffer("Resources/Sound/jumpland.wav")
local jumpSound = newSound(jumpBuffer)

local attackBuffer = newSoundBuffer("Resources/Sound/swish-4.wav")
local attackSound = newSound(attackBuffer)

local attackBuffer2 = newSoundBuffer("Resources/Sound/swish-7.wav")
local attackSound2 = newSound(attackBuffer2)

local damageBuffer = newSoundBuffer("Resources/Sound/hit17.mp3.flac")
local damageSound = newSound(damageBuffer)

local soundFunc = playSound
local offFunc = stopSound


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
		isAttacking = false,
		attackDamage = 10,
		attackPushBack = {x = 100, y = -600},
		timeSinceDamage = 0.0,
		timeSinceShake = 1.0,
		textureHPBarBack = newTexture("Resources/Sprites/Player/hpbarback.png"),
		textureHPBar = newTexture("Resources/Sprites/Player/hpbar.png"),
		spriteHPBarBack,
		spriteHPBar,
		standardAnimationTime = 0.05,

		--Charge attack
		chargeTimeMax = 1,
		chargeTime = 0,
		startCharging = false,
		releaseCharge = false,
    }
	
	this.entity.x = 10 * 48
	this.entity.y = 16 * 48
	this.entity.collision_width = 43
	this.entity.collision_height = 72
	this.entity.offsetX = 40
	this.entity.offsetY = 48
	this.entity.width = 120
	this.entity.height = 120
	this.entity.maxSpeed.x = 500
	this.entity.maxSpeed.y = 1000
	this.entity.hasGravity = true
	this.entity.canFly = false
	this.entity.texture = newTexture("Resources/Sprites/Player/player_sprite.png")
	this.entity.spriteWidth = 164
	this.entity.spriteHeight = 144
	this.entity:addAnimation(1,4) -- Idle = 1
	this.entity:addAnimation(19, 32) -- Run = 2
	this.entity:addAnimation(13, 13) -- Hurt = 3
	this.entity:addAnimation(14, 14) -- Jump up = 4
	this.entity:addAnimation(15, 15) -- Jump in air = 5
	this.entity:addAnimation(16, 16) -- Fall = 6
	this.entity:addAnimation(5,7) -- Attack = 7
	this.entity:addAnimation(33, 33) -- Dash = 8
	this.entity:addAnimation(34, 34) -- Charge attack start = 9
	this.entity:addAnimation(35, 36) -- Charge attack slash = 10
	this.entity:setAnimation(1)
	this.entity.updateAnimationTime = 0.05
	this.entity.normalMap = newTexture("Resources/Sprites/Player/player_normals.png")
	this.entity.sprite = newSprite(this.entity.width, this.entity.height, this.entity.normalMap, this.entity.texture)
	spritePos(this.entity.sprite, this.entity.x, this.entity.y)
	setSpriteRect(this.entity.sprite,0,0,86,95)

	this.powerTable = 
	{
		false,	--Dash
		false,	--Speed
		false,	--DoubleJump
		false,	--HighJump
		false	--Laser
	}

	loadPowerup(this.powerTable)

	this.entity.hasPowerUp = this.powerTable
	
	--Player Visible collision box
	--[[this.entity.textureHB = newTexture("Resources/Sprites/hitbox.png")
	this.entity.normalHB = newTexture("Resources/Sprites/hitbox_normal.png")
	this.entity.spriteHB = newSprite(this.entity.collision_width, this.entity.collision_height, this.entity.normalHB, this.entity.textureHB)
	spritePos(this.entity.spriteHB, this.entity.x + this.entity.offsetX, this.entity.y + this.entity.offsetY)]]

    setmetatable(this, self)
    return this
end

function Player:reset()
	for i, powerup in ipairs(self.powerTable) do
		self.powerTable[i] = false
	end
	savePowerup(self.powerTable)
	self.entity.hasPowerUp = self.powerTable

	for i = 11, 15, 1 do
		saveData(i, 0)
	end

end

function Player:moveRight(directionX, deltaTime)
	self.entity:accelerate(directionX, 0, deltaTime)
	
	if self.isAttacking == false then
		self.entity.updateAnimationTime = self.standardAnimationTime
		self.entity:setAnimation(2)
		
		if directionX > 0 then
			self.entity.isGoingRight = true
			if self.attackPushBack.x < 0 then
				self.attackPushBack.x = self.attackPushBack.x * -1
			end
		else
			self.entity.isGoingRight = false
			if self.attackPushBack.x > 0 then
				self.attackPushBack.x = self.attackPushBack.x * -1
			end
		end
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
		 offFunc(walkSound)
		 offFunc(attackSound)
		 soundFunc(jumpSound)
		 self.entity.velocity.y = self.jumpPower
		 self.nrOfJumps = self.nrOfJumps - 1
		 self.isJumping = true
	end

	return false
end

function Player:attack()
	if self.isAttacking == false then
		soundFunc(attackSound)
		self.entity.updateAnimationTime = self.standardAnimationTime
		self.entity:setAnimation(7)
		self.isAttacking = true
		
		--Reset charge timer
		self:resetCharge()
	end

end

function Player:resetCharge()
	self.chargeTime = 0
	self.startCharging = false
	self.releaseCharge = false
end

function Player:chargeAttack()

	--Start charge timer
	if self.startCharging == false then
		self.startCharging = true
	end

end

function Player:updateChargeAttack(deltaTime)

	--Update timer
	if self.startCharging then
		self.chargeTime = self.chargeTime + deltaTime
		self.entity:setAnimation(9)
	end	

	--Check timer
	if self.chargeTime >= self.chargeTimeMax then
		self.chargeTime = 0
		self.startCharging = false
		self.releaseCharge = true
		self.isAttacking = true
		self.entity:setAnimation(10)
		soundFunc(attackSound2)
	end

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
	spriteSize(self.spriteHPBar, (self.entity.health / 100) * 400, 25)
end

local lastYVelocity = 0

function Player:update(deltaTime)
	
	self.timeSinceDamage = self.timeSinceDamage + deltaTime
	self.timeSinceShake = self.timeSinceShake + deltaTime

	if self.timeSinceShake < 0.02 then
		shakeOn()
	else
		shakeOff()
	end

	if self.timeSinceDamage < 0.02 then
		flashOn()
	else
		flashOff()
	end
	
	if self.entity.health <= 0 then
		newState("Resources/Scripts/LuaStates/gameOverState.lua")
		self:reset()
	end

	--Decelerate
	self.entity:decelerate(deltaTime)

	--Final move
	self.entity:move(self.entity.velocity.x * deltaTime, self.entity.velocity.y * deltaTime)

	--Jumping
	if self.entity.collision_bottom == true then
		self.nrOfJumps = self.maxNrOfJumps 
		
		if self.entity.velocity.x == 0 and self.isAttacking == false then
			self.entity:setAnimation(1)
			--self:setIdle()
		end
	end

	--Charge attack
	self:updateChargeAttack(deltaTime)

	--Jump animation
	if self.isJumping == true and self.isAttacking == false then
		self.entity.updateAnimationTime = self.standardAnimationTime
		self.entity:setAnimation(4)
		if self.entity.velocity.y > -300 then
			self.isJumping = false
			self.entity:setAnimation(5)
			
		end
	end

	--Walk animation
	if self.entity.velocity.x > 100 or self.entity.velocity.x < -100 then
		soundFunc(walkSound)
	end

	if self.entity.velocity.y > 300 and self.isAttacking == false then
		self.entity:setAnimation(6)
		offFunc(walkSound)
		offFunc(attackSound)
	end

	--Entity update
	local updateE = self.entity:update(deltaTime)
	
	--Attack animation
	if updateE == true and self.isAttacking == true then
		self.isAttacking = false
		self.entity:setAnimation(1)
		--self:setIdle()
	end

	if updateE == true and self.releaseCharge == true then
		self.releaseCharge = false
		self.isAttacking = false
		self.entity:setAnimation(1)
		--self:setIdle()
	end

	--Dash animation
	if self.dashing == true then
		self.entity:setAnimation(8)
	end

	if lastYVelocity - self.entity.velocity.y > 900 and lastYVelocity - self.entity.velocity.y < 1000 then
		self:takeDamage(20)
	end

	lastYVelocity = self.entity.velocity.y

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
		self.timeSinceShake = 0.0
		self.entity.velocity.y = -1000
		print "AJ!!!"
		self:resetCharge()

		self.entity:setAnimation(3)
		soundFunc(damageSound)
	end
end

function Player:healPlayer(heal)
	self.entity.health = self.entity.health + heal

	if self.entity.health > self.entity.maxHealth then
		self.entity.health = self.entity.maxHealth
	end
	self:updateHPBar()
end

function Player:setIdle()
	self.entity:setAnimation(1)
	self.entity.updateAnimationTime = 0.2

end
