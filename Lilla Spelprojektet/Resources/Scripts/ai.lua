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

	this.entity.x = 155
	this.entity.y = 155
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
		self.entity:move(self.goombaDir * self.entity.speed * deltaTime, 0)
	end
end
