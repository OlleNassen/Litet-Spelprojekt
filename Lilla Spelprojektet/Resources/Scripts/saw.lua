require("Resources/Scripts/Entity")

Saw = {}
Saw.__index = Saw

function Saw:create(posX, posY)
    local this =
    {
		entity = Entity:create(),
		type = 0,
		aquired = false,
    }

	this.entity.x = posX
	this.entity.y = posY
	this.entity.speed = 0

	this.entity.collision_width = 32
	this.entity.collision_height = 32
	this.entity.offsetX = 8
	this.entity.offsetY = 8
	this.entity.spriteWidth = 48
	this.entity.spriteHeight = 48
	this.entity.updateAnimationTime = 0.03
	this.entity:addAnimation(1,24) 

	this.entity.texture = newTexture("Resources/Sprites/Saw/saw_diffuse.png")
	this.entity.normalMap = newTexture("Resources/Sprites/Saw/saw_normal.png")
	this.entity.sprite = newSprite(this.entity.normalMap, this.entity.texture)
	spritePos(this.entity.sprite, this.entity.x, this.entity.y)

	this.entity:setAnimation(1)
	setSpriteRect(this.entity.sprite, 0, 0, 48, 48)


    setmetatable(this, self)
    return this
end

function Saw:takeDamage(entity, deltatime)
	entity:takeDamage(20)
end