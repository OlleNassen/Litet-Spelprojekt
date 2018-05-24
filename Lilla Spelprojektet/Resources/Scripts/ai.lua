Ai = {}
Ai.__index = Ai

local walkBuffer = newSoundBuffer("Resources/Sound/walk.wav")
local walkSound = newSound(walkBuffer)

local randomBuffer = newSoundBuffer("Resources/Sound/walk.wav")
local randomSound = newSound(randomBuffer)

function Ai:create(posX, posY, sizeX, sizeY)
    local this =
    {
		entity = Entity:create(),
		isJumping = false,
		timeSinceJump = 0.0,
		goombaDir = 0,
		timer = 5,
    }

	this.entity.maxHealth = 60
	this.entity.health = 60
	this.entity.x = posX
	this.entity.y = posY
	this.entity.collision_width = 30
	this.entity.collision_height = 72
	this.entity.offsetX = 48
	this.entity.offsetY = 48
	this.entity.width = sizeX
	this.entity.height = sizeY
	this.entity.maxSpeed.x = 700
	this.entity.maxSpeed.y = 1000
	this.entity.texture = newTexture("Resources/Sprites/npc/mutant_sprite_test.png")
	this.entity.normalMap = newTexture("Resources/Sprites/npc/mutant_normals_test.png")
	this.entity.spriteWidth = 144
	this.entity.spriteHeight = 144
	this.entity:addAnimation(1,8)
	this.entity.updateAnimationTime = 0.2
	this.entity.sprite = newSprite(sizeX, sizeY, this.entity.normalMap, this.entity.texture)
	spritePos(this.entity.sprite, this.entity.x, this.entity.y)

	--Entity Visible collision box
	this.entity.textureHB = newTexture("Resources/Sprites/hitbox.png")
	this.entity.normalHB = newTexture("Resources/Sprites/hitbox_normal.png")
	this.entity.spriteHB = newSprite(this.entity.collision_width, this.entity.collision_height, this.entity.normalHB, this.entity.textureHB)
	spritePos(this.entity.spriteHB, this.entity.x + this.entity.offsetX, this.entity.y + this.entity.offsetY)

    setmetatable(this, self)
    return this
end

function Ai:randomizeDirection()
	dir = 0
	if math.random() >= 0.5 then
	dir = 1
	playSound(randomSound)
	self.entity.isGoingRight = true
	else
	dir = -1
	self.entity.isGoingRight = false
	end
	return dir
end

function Ai:update(deltaTime)
	
	--GOOMBA MOVEMENT
	self.entity:update(deltaTime)	
	self.timer = self.timer + deltaTime
	if self.timer > 3 then
		self.goombaDir = self:randomizeDirection()
		self.timer = 0
	else
		if self.entity.canMove == true then
			self.entity.velocity.x = 100 * self.goombaDir
		end
	end
	self.entity:move(self.entity.velocity.x * deltaTime, self.entity.velocity.y * deltaTime)
	playSound(walkSound)
end

function Ai:attack(player)
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