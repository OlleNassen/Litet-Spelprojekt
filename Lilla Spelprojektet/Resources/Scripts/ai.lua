require("Resources/Scripts/Entity")

Ai = {}
Ai.__index = Ai

function Ai:create()
    local this =
    {
		entity = Entity:create(),
		isJumping = false,
		timeSinceJump = 0.0,
		goombaDir = 0,
		timer = 5,
    }

	this.entity.x = 1055
	this.entity.y = 1055
	this.entity.maxSpeed.x = 700
	this.entity.maxSpeed.y = 1000
	this.entity.texture = newTexture("Resources/Sprites/goomba.png")
	this.entity.sprite = newSprite(this.entity.texture)
	spritePos(this.entity.sprite, this.entity.x, this.entity.y)

    setmetatable(this, self)
    return this
end

function Ai:randomizeDirection()
	dir = 0
	if math.random() >= 0.5 then
	dir = 1
	else
	dir = -1
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
		player:takeDamage(50)
	end
end