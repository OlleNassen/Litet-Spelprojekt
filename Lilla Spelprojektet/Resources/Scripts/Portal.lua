Portal = {}
Portal.__index = Portal

function Portal:create(posX, posY)
    local this =
    {
		entity = Entity:create(),
		type = 0,
		aquired = false,
    }

	this.entity.x = posX
	this.entity.y = posY
	this.entity.speed = 0

	this.entity.offsetX = 12
	this.entity.collision_width = 24
	this.entity.collision_height = 96
	this.entity.texture = newTexture("Resources/Sprites/door_diffuse.png")
	this.entity.normalMap = newTexture("Resources/Sprites/door_normal.png")
	this.entity.sprite = newSprite(this.entity.normalMap, this.entity.texture)
	this.entity:setSize(48, 96)

	spritePos(this.entity.sprite, this.entity.x, this.entity.y)

    setmetatable(this, self)
    return this
end

function Portal:checkType(entity)
	entity.hasPortal[self.type + 1] = true
end

function Portal:contains(entity)
	if self.aquired == false and (self.entity:contains(entity.x, entity.y) or
		self.entity:contains(entity.x + entity.width, entity.y) or
		self.entity:contains(entity.x, entity.y + entity.height) or
		self.entity:contains(entity.x + entity.width, entity.y + entity.height)) then
	
		self:checkType(entity)
		self.aquired = true
		spritePos(self.entity.sprite, -10000, -10000)

	end
end

function Portal:activatePortal(entity)
	self:checkType(entity)
	self.aquired = true
	spritePos(self.entity.sprite, -10000, -10000)
end

function Portal:disablePortal()
	self.aquired = true
	spritePos(self.entity.sprite, -10000, -10000)
end