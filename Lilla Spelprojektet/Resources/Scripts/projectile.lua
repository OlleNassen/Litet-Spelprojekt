require("Resources/Scripts/Entity")

Boss = {}
Boss.__index = Boss

function Boss:create(posX, posY, sizeX, sizeY)
    local this =
    {
		entity = Entity:create(),
		currentState = 0, -- 0 = idle, 1 = close attack, 2 = rangeAttack
		idleTimer = 0.00,
		stopIdleTimer = 2.00,
    }

	this.entity.x = posX
	this.entity.y = posY
	this.entity.collision_width = 50
	this.entity.collision_height = 50
	this.entity.offsetX = 58
	this.entity.offsetY = 48
	this.entity.width = sizeX
	this.entity.height = sizeY
	this.entity.maxSpeed.x = 700
	this.entity.maxSpeed.y = 1000
	this.entity.constantMovement = true
	this.entity.texture = newTexture("Resources/Sprites/npc/boss_sprite.png")
	this.entity.normalMap = newTexture("Resources/Sprites/npc/boss_normals.png")
	this.entity.spriteWidth = 192
	this.entity.spriteHeight = 192
	this.entity:addAnimation(1,1) -- idle = 1
	this.entity:addAnimation(2,5) -- close attack = 2
	this.entity:addAnimation(6,6) -- range attack = 3
	this.entity:setAnimation(1)
	this.entity.updateAnimationTime = 0.2
	this.entity.sprite = newSprite(sizeX, sizeY, this.entity.normalMap, this.entity.texture)
	spritePos(this.entity.sprite, this.entity.x, this.entity.y)

	--Entity Visible collision box
	--[[this.entity.textureHB = newTexture("Resources/Sprites/hitbox.png")
	this.entity.normalHB = newTexture("Resources/Sprites/hitbox_normal.png")
	this.entity.spriteHB = newSprite(this.entity.collision_width, this.entity.collision_height, this.entity.normalHB, this.entity.textureHB)
	spritePos(this.entity.spriteHB, this.entity.x + this.entity.offsetX, this.entity.y + this.entity.offsetY)]]

    setmetatable(this, self)
    return this
end

function Boss:update(deltaTime, player)

	hasFinished = self.entity:update(deltaTime)
	self:stateHandler(deltaTime, player)
	if self.idleTimer >= self.stopIdleTimer or (hasFinished == true and self.currentState ~= 0) then
		self:changeState(player)
	end

end