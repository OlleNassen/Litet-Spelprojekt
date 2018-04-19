require("Resources/Scripts/Entity")

Powerup = {}
Powerup.__index = Powerup

function Powerup:create()
    local this =
    {
		entity = Entity:create(),
		type = 0,
		aquired = false,
    }

	this.entity.x = 1000
	this.entity.y = 1000
	this.entity.speed = 0

	this.entity.texture = newTexture("Resources/Sprites/powerup_speed1.png")
	this.entity.sprite = newSprite(this.entity.texture)
	spritePos(this.entity.sprite, this.entity.x, this.entity.y)

    setmetatable(this, self)
    return this
end

function Powerup:checkType(entity)
	if self.type == 0 then -- speed upgrade
		entity.speed = 500
	elseif type == 1 then
		entity.speed = 1000
	end

end

function Powerup:contains(entity)
	if self.aquired == false and (self.entity:contains(entity.x, entity.y) or self.entity:contains(entity.x + entity.width, entity.y + entity.height)) then
		self:checkType(entity)
		self.aquired = true
		spritePos(self.entity.sprite, -10000, -10000)
	end
end