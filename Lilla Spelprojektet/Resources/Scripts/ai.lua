require("Resources/Scripts/Entity")

Ai = {}
Ai.__index = Ai

function Ai:create(posX, posY, sizeX, sizeY)
    local this =
    {
		entity = Entity:create(),
		isJumping = false,
		timeSinceJump = 0.0,
		goombaDir = 0,
		timer = 5,
    }

	this.entity.x = posX
	this.entity.y = posY
	this.entity.width = sizeX
	this.entity.height = sizeY
	this.entity.maxSpeed.x = 700
	this.entity.maxSpeed.y = 1000
	this.entity.texture = newTexture("Resources/Sprites/npc/mutant_sprite.png")
	this.entity.normalMap = newTexture("Resources/Sprites/npc/mutant_normals.png")
	this.entity.spriteWidth = 144
	this.entity.spriteHeight = 144
	this.entity:addAnimation(1,8)
	this.entity.updateAnimationTime = 0.2
	this.entity.sprite = newSprite(sizeX, sizeY, this.entity.normalMap, this.entity.texture)
	spritePos(this.entity.sprite, this.entity.x, this.entity.y)

    setmetatable(this, self)
    return this
end

function Ai:randomizeDirection()
	dir = 0
	if math.random() >= 0.5 then
	dir = 1
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
		self.entity:accelerate(self.goombaDir, 0, deltaTime)
		self.entity:move(self.entity.velocity.x * deltaTime, self.entity.velocity.y * deltaTime)
	end
end

function Ai:attack(player)
	if self.entity:contains(player.entity.x, player.entity.y) or
		self.entity:contains(player.entity.x + player.entity.width, player.entity.y) or
		self.entity:contains(player.entity.x, player.entity.y + player.entity.height) or
		self.entity:contains(player.entity.x + player.entity.width, player.entity.y + player.entity.height) then
		player:takeDamage(20)
	end
end