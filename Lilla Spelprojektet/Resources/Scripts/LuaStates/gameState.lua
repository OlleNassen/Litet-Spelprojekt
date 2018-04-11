require("Resources/Scripts/Entity")
require("Resources/Scripts/World")
require("Resources/Scripts/tilemap1")

local level = World:create()
level:addMap(tilemap1)
level:loadGraphics()

isJumping = false
timeSinceJump = 0.0

local p = Entity:create() -- player
p.x = 50
p.y = 50

local g = Entity:create() -- goomba
g.x = 155
g.y = 155

level:addEntity(p)
level:addEntity(g)

function moveRight(direction, deltaTime)
	p:move(direction * p.speed * deltaTime, 0)
	return true
end

function jump()
	isJumping = true
end

function playerPosition()
	return p.y, p.x
end

function goombaPosition()
	return g.y, g.x
end

function update(deltaTime)

	if isJumping then
		
		timeSinceJump = timeSinceJump + deltaTime
		p:move(0, -100 * deltaTime)
		
		if timeSinceJump > 1.0 then
			isJumping = false
			timeSinceJump = 0.0
		end
	else
		p:move(0, 100 * deltaTime)

	end


	if math.random() > 0.5 then
		g:move(100 * deltaTime, 0)
	else
		g:move(-100 * deltaTime, 0)
	end
	return true
end

