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
p.speed = 200
p.texture = newTexture("Resources/Sprites/brick_diffuse.png")
p.normalMap = newTexture("Resources/Sprites/brick_normal.png")
p.sprite = newSprite(p.normalMap, p.texture)
p:addWorld(level)
p:setPosition(100, 100)

local s = Entity:create() -- pixie
s.x = 200
s.y = 100
s.speed = 200
s.texture = newTexture("Resources/Sprites/mouseDiffuse.png")
s.normalMap = newTexture("Resources/Sprites/mouseNormal.png")
s.sprite = newSprite(s.normalMap, s.texture)
s:addWorld(level)

local tileType = 0

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
	s:setPosition(p.x + mX, p.y + mY)
	--print(mX, mY)
end

function mouseLeft()
	local position = {x, y}
	position.x = math.floor((p.x + mX) / 48)
	position.y = math.floor((p.y + mY) / 48)
	
	--print(((p.x + mX) / 48), ((p.y + mY) / 48))
	--print(position.x, position.y)

	local index = position.y * level.map.width + position.x
	print(index + 1)
	local tile  = level.map.tiles[index + 1]

	if tile ~= tileType then
		level.map.tiles[index + 1] = tileType
		reloadTile(index, tileType)
	end

end

function update(deltatime)
	--s:setPosition(p.x + mX, p.y + mY)
end

function quit(direction, deltaTime)
	pop()
end

function update()
	return true
end

function key1()
	tileType = 0
end

function key2()
	tileType = 1	
end

function key3()
	tileType = 2	
end

function save()
	--level.map.tiles
	--level.map.height
	--level.map.width
	--name
	
	local file = io.open("Resources/Scripts/saveTest.lua", "w")
	print("Open done")
	
	--Name
	file:write("tilemap1 =\n{\n")

	--Write texture diffuse
	file:write("\ttexturesDiffuse =\n\t{\n")
	for k, v in pairs(level.map.texturesDiffuse) do
		file:write("\t\t", level.map.texturesDiffuse[k], ",\n")
	end
	file:write("\t},\n\n")

	--Write texture diffuse
	file:write("\ttexturesNormal =\n\t{\n")
	for k, v in pairs(level.map.texturesNormal) do
		file:write("\t\t", level.map.texturesNormal[k], ",\n")
	end
	file:write("\t},\n")

	--Write tiles
	file:write("\n\ttiles = \n\t{")
	for i, k in pairs(level.map.tiles) do
		if i == 1 then
			file:write("\n\t\t")
		end
		file:write(k)
		if i ~= level.map.width * level.map.height then
			file:write(",")
		end
		if i % level.map.width == 0 and i ~= level.map.width * level.map.height then
			file:write("\n\t\t")
		end
	end
	file:write("\n\t},\n")

	
	file:write("\n\twidth =", level.map.width, "\n")
	file:write("\theight =", level.map.height, "\n")
	file:write("}")

	io.close(file)
	print("Save done")
end