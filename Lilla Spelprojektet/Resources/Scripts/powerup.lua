require("Resources/Scripts/Entity")

Powerup = {}
Powerup.__index = Powerup

function Powerup:create()
    local this =
    {
		entity = Entity:create(),
		type = 0,
    }

	this.entity.x = 1000
	this.entity.y = 1000
	this.entity.speed = 0

	this.entity.texture = newTexture("Resources/Sprites/donald_trump.png")
	this.entity.sprite = newSprite(this.entity.texture)
	spritePos(this.entity.sprite, this.entity.x, this.entity.y)

    setmetatable(this, self)
    return this
end

function Powerup:contains(entity)
	if self.entity:contains(entity.x, entity.y) or self.entity:contains(entity.width, entity.height) then
		entity.speed = 400
	end
end