require("Resources/Scripts/Entity")

Boss = {}
Boss.__index = Boss

function Boss:create(posX, posY, sizeX, sizeY)
    local this =
    {
		entity = Entity:create(),
		currentState = 0, -- 0 = idle, 1 = close attack, 2 = rangeAttack
		idleTimer = 0.00,
		stopIdleTimer = 2.00,
		hasShot = false,
		p = {},
    }

	this.entity.x = posX
	this.entity.y = posY
	this.entity.collision_width = 13
	this.entity.collision_height = 72
	this.entity.offsetX = 58
	this.entity.offsetY = 48
	this.entity.width = sizeX
	this.entity.height = sizeY
	this.entity.maxSpeed.x = 700
	this.entity.maxSpeed.y = 1000
	this.entity.texture = newTexture("Resources/Sprites/npc/boss_sprite.png")
	this.entity.normalMap = newTexture("Resources/Sprites/npc/boss_normals.png")
	this.entity.spriteWidth = 192
	this.entity.spriteHeight = 192
	this.entity:addAnimation(1,1) -- idle = 1
	this.entity:addAnimation(2,5) -- close attack = 2
	this.entity:addAnimation(6,6) -- range attack = 3
	this.entity:setAnimation(2)
	this.entity.updateAnimationTime = 0.2
	this.entity.sprite = newSprite(sizeX, sizeY, this.entity.normalMap, this.entity.texture)
	spritePos(this.entity.sprite, this.entity.x, this.entity.y)

	--Entity Visible collision box
	--[[this.entity.textureHB = newTexture("Resources/Sprites/hitbox.png")
	this.entity.normalHB = newTexture("Resources/Sprites/hitbox_normal.png")
	this.entity.spriteHB = newSprite(this.entity.collision_width, this.entity.collision_height, this.entity.normalHB, this.entity.textureHB)
	spritePos(this.entity.spriteHB, this.entity.x + this.entity.offsetX, this.entity.y + this.entity.offsetY)]]

    setmetatable(this, self)
    return this
end

function Boss:update(deltaTime, player)

	hasFinished = self.entity:update(deltaTime)
	self:stateHandler(deltaTime, player)
	if self.idleTimer >= self.stopIdleTimer or (hasFinished == true and self.currentState ~= 0) then
		self:changeState(player)
	end

	if player.isAttacking == true and player.entity.isGoingRight == true then
		if self.entity:contains(player.entity.x + player.entity.width - 50, player.entity.y + (player.entity.height / 2)) == true then
			self:takeDamage(50)
		end

	elseif  player.isAttacking == true and player.entity.isGoingRight == false then
		if self.entity:contains(player.entity.x + 50, player.entity.y + (player.entity.height / 2)) == true then
			self:takeDamage(50)
		end
	end

	-- Projectile loop
	for i = #self.p, 1, -1 do
		self.p[i]:update(deltaTime)
		self.p[i]:move(self.p[i].velocity.x * deltaTime, self.p[i].velocity.y * deltaTime)
		if self.p[i].collision_left == true or self.p[i].collision_right == true or self.p[i].collision_top == true or self.p[i].collision_bottom == true then
			self.p[i].velocity.y = 0
			self.p[i].velocity.x = 0
			self:pAttack(i, player)
			self:pAttack(i, self)
			-- Add check if expolsion animation is done
			table.remove(self.p, i)
		else
			if player.isAttacking == true and player.entity.isGoingRight == true then
				if self.p[i]:contains(player.entity.x + player.entity.width - 50, player.entity.y + (player.entity.height / 2)) == true then
					self:pInvertVelocity(i)
				end

			elseif  player.isAttacking == true and player.entity.isGoingRight == false then
				if self.p[i]:contains(player.entity.x + 50, player.entity.y + (player.entity.height / 2)) == true then
					self:pInvertVelocity(i)
				end

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
	elseif self.currentState == 2 then
		self.entity:setAnimation(3)
		if self.hasShot == false then
			self:createProjectile(player, deltaTime)
		end
	else
		print("ERROR: Boss state not found")
	end
end

function Boss:changeState(player)
	
	self.idleTimer = 0.00
	if self.currentState == 0 then
		local distance = math.abs(player.entity.x - self.entity.x)

		if distance <= 500 then
			self.currentState = 2
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

function Boss:pInvertVelocity(index)
	self.p[index].velocity.x = self.p[index].velocity.x * -1
	self.p[index].velocity.y = self.p[index].velocity.y * -1
end

function Boss:pAttack(index, player)
	if self.p[index]:containsCollisionBox(player) then
		player:takeDamage(20)
	end
end

function Boss:createProjectile(player, deltaTime)
	table.insert(self.p, Entity:create())
	self.p[#self.p].x = self.entity.x - 20
	self.p[#self.p].y = self.entity.y + (self.entity.height / 3)
	self.p[#self.p].collision_width = 48
	self.p[#self.p].collision_height = 48
	self.p[#self.p].offsetX = 0
	self.p[#self.p].offsetY = 0
	self.p[#self.p].width = 48
	self.p[#self.p].height = 48
	self.p[#self.p].maxSpeed.x = 700
	self.p[#self.p].maxSpeed.y = 1000
	self.p[#self.p].texture = newTexture("Resources/Sprites/npc/boss_sprite.png")
	self.p[#self.p].normalMap = newTexture("Resources/Sprites/npc/boss_normals.png")
	self.p[#self.p].spriteWidth = 192
	self.p[#self.p].spriteHeight = 192
	self.p[#self.p]:addAnimation(1,1)
	self.p[#self.p].updateAnimationTime = 0.2
	self.p[#self.p].sprite = newSprite(sizeX, sizeY, self.p[#self.p].normalMap, self.p[#self.p].texture)
	spritePos(self.p[#self.p].sprite, self.p[#self.p].x, self.p[#self.p].y)
	self.p[#self.p].constantMovement = true
	self.p[#self.p].hasGravity = false
	self.p[#self.p]:addWorld(self.entity.world)
	
	self.p[#self.p]:setAnimation(1)
	self.p[#self.p]:updateAnimation(1)
	local vector = {x = player.entity.x - self.p[#self.p].x, y = (player.entity.y + (player.entity.height / 2)) - self.p[#self.p].y}
	local length = math.sqrt((vector.x * vector.x) + (vector.y * vector.y))
	vector.x = vector.x / length
	vector.y = vector.y / length
	self.p[#self.p].velocity.x = vector.x * 500
	self.p[#self.p].velocity.y = vector.y * 500
	self.p[#self.p]:accelerate(vector.x ,vector.y, deltaTime)
	self.hasShot = true
end

function Boss:takeDamage(damage)
	
	self.entity:takeDamage(50,0,0)

	if self.entity.health <= 0 then
		self.entity.x = -5000
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
		player:takeDamage(20)
	end
end