require("Resources/Scripts/Entity")

Boss = {}
Boss.__index = Boss

function Boss:create(posX, posY, sizeX, sizeY)
    local this =
    {
		entity = Entity:create(),
		isJumping = false,
		timeSinceJump = 0.0,
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
	
	distance = math.abs(player.entity.x - self.entity.x)
	
	if distance < 500 then
		self.entity:setAnimation(2)
	
	elseif distance < 5000 then
		-- add projectile
				self.entity:setAnimation(1)
	else

	end

	--print(distance)

	self.entity:update(deltaTime)
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