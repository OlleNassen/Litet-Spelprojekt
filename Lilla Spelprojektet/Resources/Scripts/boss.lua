require("Resources/Scripts/Entity")

local dieBuffer = newSoundBuffer("Resources/Sound/giant2.wav")
local dieSound = newSound(dieBuffer)

local shootBuffer = newSoundBuffer("Resources/Sound/mnstr1.wav")
local shootSound = newSound(shootBuffer)

local meleeBuffer = newSoundBuffer("Resources/Sound/mnstr9.wav")
local meleeSound = newSound(meleeBuffer)

local splashBuffer = newSoundBuffer("Resources/Sound/slime9.wav")
local splashSound = newSound(splashBuffer)

Boss = {}
Boss.__index = Boss

function Boss:create(posX, posY, sizeX, sizeY)
    local this =
    {
		entity = Entity:create(),
		hitBoxClose = Entity:create(),
		currentState = 0, -- 0 = idle, 1 = close attack, 2 = rangeAttack
		idleTimer = 0.00,
		stopIdleTimer = 2.00,
		hasShot = false,
		firstFrame = true,
		p = {},
		pTexture = newTexture("Resources/Sprites/npc/projectile_sprite.png"),
		pNormal = newTexture("Resources/Sprites/npc/projectile_normals.png"),

		textureBossHPBarBack = newTexture("Resources/Sprites/Player/hpbarback.png"),
		textureBossHPBar = newTexture("Resources/Sprites/Player/bossHPbar.png"),
		spriteBossHPBarBack,
		spriteBossHPBar,
		idleProjectiles = {},
    }

	this.entity.x = posX
	this.entity.y = posY
	this.entity.collision_width = sizeX
	this.entity.collision_height = sizeY
	this.entity.offsetX = 100
	this.entity.offsetY = 100
	this.entity.width = sizeX
	this.entity.height = sizeY
	this.entity.maxSpeed.x = 700
	this.entity.maxSpeed.y = 1000
	this.entity.texture = newTexture("Resources/Sprites/npc/boss_sprite_new.png")
	this.entity.normalMap = newTexture("Resources/Sprites/npc/boss_normal_new.png")
	this.entity.spriteWidth = 192
	this.entity.spriteHeight = 192
	this.entity:addAnimation(1,4) -- idle = 1
	this.entity:addAnimation(5,8) -- close attack = 2
	this.entity:addAnimation(9,11) -- range attack = 3
	this.entity:setAnimation(1)
	this.entity.updateAnimationTime = 0.25
	this.entity.sprite = newSprite(sizeX, sizeY, this.entity.normalMap, this.entity.texture)
	spritePos(this.entity.sprite, this.entity.x, this.entity.y)

	this.hitBoxClose.x = this.entity.x + (48/2)
	this.hitBoxClose.y = this.entity.y + this.entity.height - (48 * 2)
	this.hitBoxClose.collision_width = 48 + 24
	this.hitBoxClose.collision_height = 48 * 2

	--Entity Visible collision box
	--[[this.entity.textureHB = newTexture("Resources/Sprites/hitbox.png")
	this.entity.normalHB = newTexture("Resources/Sprites/hitbox_normal.png")
	this.entity.spriteHB = newSprite(this.entity.collision_width, this.entity.collision_height, this.entity.normalHB, this.entity.textureHB)
	spritePos(this.entity.spriteHB, this.entity.x + this.entity.offsetX, this.entity.y + this.entity.offsetY)]]

    setmetatable(this, self)
    return this
end

function Boss:update(deltaTime, player)

	
	if self.firstFrame == true then
		for i = 1, 10, 1 do
			self:createProjectile()
		end
		
		self.firstFrame = false
	end
	
	self:attack(player)
	self:playerAttack(player)
	hasFinished = self.entity:update(deltaTime)
	self:stateHandler(deltaTime, player)
	if self.idleTimer >= self.stopIdleTimer or (hasFinished == true and self.currentState ~= 0) then
		self:changeState(player)
	end

	-- Projectile loop
	for i = #self.p, 1, -1 do
	 	local pDone = self.p[i]:update(deltaTime)
		self:pAttack(i, player)
		self.p[i]:move(self.p[i].velocity.x * deltaTime, self.p[i].velocity.y * deltaTime)
		if self.p[i].collision_left == true or self.p[i].collision_right == true or self.p[i].collision_top == true or self.p[i].collision_bottom == true then
			self.p[i].velocity.y = 0
			self.p[i].velocity.x = 0
			self.p[i]:setAnimation(2)
			pDone = false
			--self:pAttack(i, self)
			-- Add check if expolsion animation is done
		else
			self:pPlayerAttack(i, player)
		end

		if pDone == true and self.p[i].currentAnimation == 2 then
			self:removeProjectile(i)
		end
	end
end


function Boss:playerAttack(player)
		if player.isAttacking and player.releaseCharge == false then
			if player.entity.isGoingRight == true then
				if self.entity:contains(player.entity.x + player.entity.width - 50, player.entity.y + (player.entity.height / 2)) == true then
					self:takeDamage(player.attackDamage)
				end

			elseif player.entity.isGoingRight == false then
				if self.entity:contains(player.entity.x + 50, player.entity.y + (player.entity.height / 2)) == true then
					self:takeDamage(player.attackDamage)
				end

			end
		end

		--Charge attack (right and left resp.)
		if player.isAttacking and player.releaseCharge then

			if player.isAttacking == true and player.entity.isGoingRight == true then
				if self.entity:contains(player.entity.x + player.entity.width - 40, player.entity.y + (player.entity.height / 2)) == true then
					self:takeDamage(player.attackDamage * 3)
				end

			elseif  player.isAttacking == true and player.entity.isGoingRight == false then
				if self.entity:contains(player.entity.x + 40, player.entity.y + (player.entity.height / 2)) == true then
					self:takeDamage(player.attackDamage * 3)
				end

			end
		end
end

----- STATE HANDLERS -----

function Boss:stateHandler(deltaTime, player)
	if self.currentState == 0 then
		self.entity:setAnimation(1)
		self.idleTimer = self.idleTimer + deltaTime
	elseif self.currentState == 1 then
		self.entity:setAnimation(2)

		if self.entity.currentAnimationIndex == 6 or self.entity.currentAnimationIndex == 8 then
			playSound(meleeSound)

			if self.hitBoxClose:containsCollisionBox(player) then
				player:takeDamage(20, -2000)
			end
		end
	elseif self.currentState == 2 then
		self.entity:setAnimation(3)
		if self.hasShot == false and self.entity.currentAnimationIndex == 11 then
			self:addProjectile(player, deltaTime)
		end
	else
		print("ERROR: Boss state not found")
	end
end

function Boss:changeState(player)
	
	self.idleTimer = 0.00
	if self.currentState == 0 then
		local distance = math.abs(player.entity.x - self.entity.x)

		if distance <= 48 then
			self.currentState = 1
		elseif distance <= 1000 then
			self.currentState = 2
		else
			self.currentState = 0
		end
	else
		self.currentState = 0
		self.hasShot = false
	end
end

----- PROJECTILE HANDLERS -----

function Boss:pInvertVelocity(index, multi)
	self.p[index].velocity.x = self.p[index].velocity.x * -1 * (multi or 1)
	self.p[index].velocity.y = self.p[index].velocity.y * -1 * (multi or 1)
end

function Boss:pPlayerAttack(index, player)

		if player.isAttacking and player.releaseCharge == false and player.entity.currentAnimationIndex == 6 then
			if player.entity.isGoingRight == true then
				if self.p[index]:contains(player.entity.x + player.entity.width - 50, player.entity.y + (player.entity.height / 2)) == true then
					self:pInvertVelocity(index)
				end

			elseif player.entity.isGoingRight == false then
				if self.p[index]:contains(player.entity.x + 50, player.entity.y + (player.entity.height / 2)) == true then
					self:pInvertVelocity(index)
				end

			end
		end

		--Charge attack (right and left resp.)
		if player.isAttacking and player.releaseCharge and player.entity.currentAnimationIndex == 35 then
			if player.isAttacking == true and player.entity.isGoingRight == true then
				if self.p[index]:contains(player.entity.x + player.entity.width - 40, player.entity.y + (player.entity.height / 2)) == true then
					self:pInvertVelocity(index, 2)
				end

			elseif  player.isAttacking == true and player.entity.isGoingRight == false then
				if self.p[index]:contains(player.entity.x + 40, player.entity.y + (player.entity.height / 2)) == true then
					self:pInvertVelocity(index, 2)
				end

			end
		end
end

function Boss:pAttack(index, player)
	if self.p[index]:containsCollisionBox(player) and self.p[index].velocity.x ~= 0 and self.p[index].velocity.y ~= 0 then
		player:takeDamage(10)
	elseif self.p[index]:containsCollisionBox(self) and self.p[index].velocity.x > 1 then
		if 	math.sqrt((self.p[index].velocity.x * self.p[index].velocity.x) + (self.p[index].velocity.y * self.p[index].velocity.y)) >= 1500 then
			self:takeDamage(30)
		else
			self:takeDamage(10)
		end
	end
end

function Boss:createProjectile()
	table.insert(self.idleProjectiles, Entity:create())
	
	self.idleProjectiles[#self.idleProjectiles].x = -1000
	self.idleProjectiles[#self.idleProjectiles].y = 0
	self.idleProjectiles[#self.idleProjectiles].collision_width = 48
	self.idleProjectiles[#self.idleProjectiles].collision_height = 30
	self.idleProjectiles[#self.idleProjectiles].offsetX = 33
	self.idleProjectiles[#self.idleProjectiles].offsetY = 33
	self.idleProjectiles[#self.idleProjectiles].width = 48 * 2
	self.idleProjectiles[#self.idleProjectiles].height = 48 * 2
	self.idleProjectiles[#self.idleProjectiles].maxSpeed.x = 700
	self.idleProjectiles[#self.idleProjectiles].maxSpeed.y = 1000
	self.idleProjectiles[#self.idleProjectiles].texture = self.pTexture
	self.idleProjectiles[#self.idleProjectiles].normalMap = self.pNormal
	self.idleProjectiles[#self.idleProjectiles].spriteWidth = 144
	self.idleProjectiles[#self.idleProjectiles].spriteHeight = 144
	self.idleProjectiles[#self.idleProjectiles]:addAnimation(1,1)
	self.idleProjectiles[#self.idleProjectiles]:addAnimation(1,4)
	self.idleProjectiles[#self.idleProjectiles]:setAnimation(1)
	self.idleProjectiles[#self.idleProjectiles].updateAnimationTime = 0.05
	self.idleProjectiles[#self.idleProjectiles].sprite = newSprite(self.idleProjectiles[#self.idleProjectiles].width, self.idleProjectiles[#self.idleProjectiles].height, self.idleProjectiles[#self.idleProjectiles].normalMap, self.idleProjectiles[#self.idleProjectiles].texture)
	spritePos(self.idleProjectiles[#self.idleProjectiles].sprite, self.idleProjectiles[#self.idleProjectiles].x, self.idleProjectiles[#self.idleProjectiles].y)
	self.idleProjectiles[#self.idleProjectiles].constantMovement = true
	self.idleProjectiles[#self.idleProjectiles].hasGravity = false
	self.idleProjectiles[#self.idleProjectiles]:addWorld(self.entity.world)
end

function Boss:addProjectile(player, deltaTime)

	table.insert(self.p, self.idleProjectiles[1])
	table.remove(self.idleProjectiles, 1)
	self.p[#self.p]:setAnimation(1)
	self.p[#self.p].x = self.entity.x + (self.entity.width / 5)
	self.p[#self.p].y = self.entity.y + (self.entity.height / 3)
	self.p[#self.p]:updateAnimation(1)
	local vector = {x = player.entity.x - self.p[#self.p].x, y = (player.entity.y + 24) - self.p[#self.p].y + 24}
	local length = math.sqrt((vector.x * vector.x) + (vector.y * vector.y))
	vector.x = (vector.x / length) * 1000
	vector.y = (vector.y / length) * 1000

	self.p[#self.p].velocity.x = vector.x
	self.p[#self.p].velocity.y = vector.y
	print(self.p[#self.p].velocity.y)
	self.hasShot = true
	playSound(shootSound)

	--Player Visible collision box
end

function Boss:removeProjectile(index)
	table.insert(self.idleProjectiles, self.p[index])
	table.remove(self.p, index)
	self.idleProjectiles[#self.idleProjectiles]:setPosition(-1000, 0)
	playSound(splashSound)
end

function Boss:updateHpBar()
	if self.entity.health < 0 then
		self.entity.health = 0
	end
	spriteSize(self.spriteBossHPBar, (self.entity.health / 100) * -400, 25)
end

function Boss:takeDamage(damage)
	
	self.entity:takeDamage(damage, 0, 0)
	self:updateHpBar()

	if self.entity.health <= 0 then
		self.entity.x = -5000
		playSound(dieSound)
	end

	print("AAARRRGHHH!!")
end

function Boss:attack(player)
	--[[if self.entity:contains(player.entity.x, player.entity.y) or
		self.entity:contains(player.entity.x + player.entity.width, player.entity.y) or
		self.entity:contains(player.entity.x, player.entity.y + player.entity.height) or
		self.entity:contains(player.entity.x + player.entity.width, player.entity.y + player.entity.height) then]]
	
	--[[if self.entity:containsCollisionBox(player.entity.x + player.entity.offsetX, player.entity.y + player.entity.offsetY) or --top left
		self.entity:containsCollisionBox(player.entity.x + player.entity.offsetX + player.entity.collision_width, player.entity.y + player.entity.offsetY) or --top right 
		self.entity:containsCollisionBox(player.entity.x + player.entity.offsetX, player.entity.y + player.entity.offsetY + player.entity.collision_height) or --bottom left 
		self.entity:containsCollisionBox(player.entity.x + player.entity.offsetX + player.entity.collision_width, player.entity.y + player.entity.offsetY + player.entity.collision_height) then]] --bottom right

	if self.entity:containsCollisionBox(player) then
		player:takeDamage(20, -1000)
	end
end