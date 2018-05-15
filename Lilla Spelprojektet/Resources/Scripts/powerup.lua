require("Resources/Scripts/Entity")

Powerup = {}
Powerup.__index = Powerup

powerUpTypes = {}
powerUpTypes["dash"] = { 0, "Resources/Sprites/PowerUps/powerupDash_diffuse.png" }
powerUpTypes["speed"] = { 1, "Resources/Sprites/PowerUps/powerupSpeed_diffuse.png" }
powerUpTypes["doubleJump"] = { 2, "Resources/Sprites/PowerUps/powerupdoubleJump_diffuse.png" }
powerUpTypes["highJump"] = { 3, "Resources/Sprites/PowerUps/powerupHighJump_diffuse.png" }
powerUpTypes["laser"] = { 4, "Resources/Sprites/PowerUps/powerupLaser_diffuse.png" }

function Powerup:create(type, posX, posY)
    local this =
    {
		entity = Entity:create(),
		type = 0,
		aquired = false,
    }

	this.entity.x = posX
	this.entity.y = posY
	this.entity.speed = 0

	this.entity.collision_width = 16
	this.entity.collision_height = 42
	this.entity.offsetX = 16
	this.entity.offsetY = 3
	this.entity.spriteWidth = 48
	this.entity.spriteHeight = 48
	this.entity.updateAnimationTime = 0.05
	this.entity:addAnimation(1,17) 

	this.entity.texture = newTexture(powerUpTypes[type][2])
	this.entity.normalMap = newTexture("Resources/Sprites/PowerUps/powerup_normal.png")
	this.entity.sprite = newSprite(this.entity.normalMap, this.entity.texture)
	spritePos(this.entity.sprite, this.entity.x, this.entity.y)

	this.entity:setAnimation(1)
	setSpriteRect(this.entity.sprite, 0, 0, 48, 48)
	
	this.type = powerUpTypes[type][1]

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

function Powerup:activatePowerUp(entity)
	self:checkType(entity)
	self.aquired = true
	spritePos(self.entity.sprite, -10000, -10000)
end