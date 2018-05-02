require("Resources/Scripts/Entity")

Powerup = {}
Powerup.__index = Powerup

function Powerup:create(texture, normalMap)
    local this =
    {
		entity = Entity:create(),
		type = 0,
		aquired = false,
    }

	this.entity.x = 1000
	this.entity.y = 1000
	this.entity.speed = 0

	this.entity.texture = newTexture(texture)
	this.entity.normalMap = newTexture(normalMap)
	this.entity.sprite = newSprite(this.entity.normalMap, this.entity.texture)
	spritePos(this.entity.sprite, this.entity.x, this.entity.y)

    setmetatable(this, self)
    return this
end

function Powerup:checkType(entity)
	entity.hasPowerUp[self.type + 1] = true
end

function Powerup:contains(entity)
	if self.aquired == false and (self.entity:contains(entity.x, entity.y) or
		self.entity:contains(entity.x + entity.width, entity.y) or
		self.entity:contains(entity.x, entity.y + entity.height) or
		self.entity:contains(entity.x + entity.width, entity.y + entity.height)) then
	
		self:checkType(entity)
		self.aquired = true
		spritePos(self.entity.sprite, -10000, -10000)

	end
end