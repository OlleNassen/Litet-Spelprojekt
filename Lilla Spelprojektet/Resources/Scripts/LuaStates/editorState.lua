require("Resources/Scripts/Entity")
require("Resources/Scripts/World")
require("Resources/Scripts/tilemap1")

function quit()
	pop()
end

local level = World:create()
level:addMap(tilemap1)
level:loadGraphics()

local p = Entity:create() -- player
p.x = 50
p.y = 50
p.speed = 200
p.texture = newTexture("Resources/Sprites/brickDiffuse.png")
p.normalMap = newTexture("Resources/Sprites/brickNormal.png")
p.sprite = newSprite(p.normalMap, p.texture)
p:addWorld(level)

local s = Entity:create() -- pixie
s.x = 200
s.y = 100
s.speed = 200
s.texture = newTexture("Resources/Sprites/mouseDiffuse.png")
s.normalMap = newTexture("Resources/Sprites/mouseNormal.png")
s.sprite = newSprite(s.normalMap, s.texture)
s:addWorld(level)

function moveUp(direction, deltaTime)
	p:move(0, -direction * p.speed * deltaTime)
	return true
end

function moveRight(direction, deltaTime)
	p:move(direction * p.speed * deltaTime, 0)
	return true
end

mX = 0.0
mY = 0.0

function mouse(x, y)
	mX = mX + x
	mY = mY + y
end

function mouseLeft()
	local position = {x, y}
	position.x = math.floor((p.x + mX) / 48)
	position.y = math.floor((p.y + mY) / 48)
	
	print(((p.x + mX) / 48), ((p.y + mY) / 48))
	print(position.x, position.y)

	local index = position.y * level.map.width + position.x
	local tile = level.map.tiles[index + 1]

	if tile == 0 then
		tile = 1
	else 
		tile = 0
	end

	level.map.tiles[index + 1] = tile

	reloadTile(index, tile)
end

function update(deltatime)
	s:setPosition(p.x + mX, p.y + mY)
end

function quit(direction, deltaTime)
	pop()
end

function update()
	return true
end