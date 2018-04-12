require("Resources/Scripts/Entity")
require("Resources/Scripts/World")
require("Resources/Scripts/tilemap1")

function quit()
	pop()
end

local level = World:create()
level:addMap(tilemap1)
level:loadGraphics()

isJumping = false
timeSinceJump = 0.0

local gravityConstant = 100

function randomizeDirection()
	dir = 0
	if math.random() >= 0.5 then
	dir = 1
	else
	dir = -1
	end
	return dir
end

--goomba stuff
local timer = 0.0
local goombaDir = randomizeDirection()

--local, doesnt work
function gravity(entity)
	entity:move(0, gravityConstant * deltaTime)
end


local p = Entity:create() -- player
p.x = 50
p.y = 50
p.speed = 200
p.texture = newTexture("Resources/Sprites/HansTap.png")
p.sprite = newSprite(p.texture)
p:addWorld(level)

local g = Entity:create() -- goomba
g.x = 155
g.y = 155
g.texture = newTexture("Resources/Sprites/goomba.png")
g.sprite = newSprite(g.texture)
g:addWorld(level)

local b = Entity:create() -- goomba
b.x = 1200
b.y = 864
b.texture = newTexture("Resources/Sprites/bossman.png")
b.sprite = newSprite(b.texture)
b:addWorld(level)
b:move(0,0)

function moveRight(direction, deltaTime)
	p:move(direction * p.speed * deltaTime, 0)
	return true
end

function jump()
	isJumping = true
end


function update(deltaTime)

	if p:contains(b.x, b.y) then
		push("Resources/Scripts/LuaStates/gameOverState.lua")
	end
	
	if isJumping then
		
		timeSinceJump = timeSinceJump + deltaTime
		p:move(0, -100 * deltaTime)
		
		if timeSinceJump > 1.0 then
			isJumping = false
			timeSinceJump = 0.0
		end
	else
		p:move(0, gravityConstant * deltaTime)
	end

	--GOOMBA MOVEMENT
	g:move(0, gravityConstant * deltaTime)
	timer = timer + deltaTime

	if timer > 3 then
		goombaDir = randomizeDirection()
		timer = 0
	else
		g:move(goombaDir * g.speed * deltaTime, 0)
	end

	return true
end

