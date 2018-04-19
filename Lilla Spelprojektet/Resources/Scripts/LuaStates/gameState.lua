require("Resources/Scripts/Entity")
require("Resources/Scripts/player")
require("Resources/Scripts/World")
require("Resources/Scripts/tilemap2")

function quit()
	pop()
end

local level = World:create()
level:addMap(tilemap2)
level:loadGraphics()

isJumping = false
timeSinceJump = 0.0

local gravityConstant = 400

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


local p = Player:create() -- player
p.entity:addWorld(level)


local s = Entity:create() -- pixie
s.x = 200
s.y = 100
s.speed = 200
s.texture = newTexture("Resources/Sprites/player.png")
s.sprite = newSprite(s.texture)
s:addWorld(level)


local g = Entity:create() -- goomba
g.x = 155
g.y = 155
g.texture = newTexture("Resources/Sprites/goomba.png")
g.sprite = newSprite(g.texture)
g:addWorld(level)

local b = Entity:create() -- goomba
b.x = 300
b.y = 200
b.texture = newTexture("Resources/Sprites/bossman.png")
b.sprite = newSprite(b.texture)
b:addWorld(level)
b:move(0,0)

function moveRight(direction, deltaTime)
	p.entity:move(direction * p.entity.speed * deltaTime, 0)
	return true
end

function jump()
	p.isJumping = true
end

mX = 0.0
mY = 0.0

function mouse(x, y)
	mX = mX + x
	mY = mY + y
end

function update(deltaTime)
	
	p:update(deltaTime)
	s:setPosition(p.entity.x + mX, p.entity.y + mY)

	--GOOMBA MOVEMENT
	g:move(0, gravityConstant * deltaTime)
	timer = timer + deltaTime

	if timer > 3 then
		goombaDir = randomizeDirection()
		timer = 0
	else
		g:move(goombaDir * g.speed * deltaTime, 0)
	end

	if p:contains(b.x, b.y) then
		push("Resources/Scripts/LuaStates/gameOverState.lua")
	end

	return true
end

