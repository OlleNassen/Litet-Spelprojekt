require("Resources/Scripts/Entity")
require("Resources/Scripts/player")
require("Resources/Scripts/ai")
require("Resources/Scripts/World")
require("Resources/Scripts/tilemap2")

function quit()
	pop()
end

local level = World:create()
level:addMap(tilemap2)
level:loadGraphics()


local p = Player:create() -- player
p.entity:addWorld(level)


local s = Entity:create() -- pixie
s.x = 200
s.y = 100
s.speed = 200
s.texture = newTexture("Resources/Sprites/player.png")
s.sprite = newSprite(s.texture)
s:addWorld(level)


local g = Ai:create() -- goomba
g.entity:addWorld(level)

local b = Entity:create() -- goomba
b.x = 300
b.y = 200
b.texture = newTexture("Resources/Sprites/bossman.png")
b.sprite = newSprite(b.texture)
b:addWorld(level)
b:move(0,0)

function moveRight(direction, deltaTime)
	return p:moveRight(direction, deltaTime)
end

function jump()
	return p:jump()
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

	g:update(deltaTime)

	if p:contains(b.x, b.y) then
		push("Resources/Scripts/LuaStates/gameOverState.lua")
	end

	return true
end

