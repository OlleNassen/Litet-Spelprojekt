require("Resources/Scripts/Entity")
require("Resources/Scripts/World")
require("Resources/Scripts/empty")
require("Resources/Scripts/Background")
package.loaded["Resources/Scripts/empty"] = nil

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
p.sprite = newSprite(1, 1, p.normalMap, p.texture)
p:setPosition(100, 100)

local s = Entity:create() -- pixie
s.x = 200
s.y = 100
s.speed = 200
s.texture = newTexture("Resources/Sprites/mouseDiffuse.png")
s.normalMap = newTexture("Resources/Sprites/mouseNormal.png")
s.sprite = newSprite(s.normalMap, s.texture)
s:addWorld(level)

local bg = Background:create()
bg.texture = newTexture("Resources/Sprites/backgroundTile_diffuse.png")
bg.normalMap = newTexture("Resources/Sprites/backgroundTile_normal.png")
bg.sprite = newBackground(720 * 10, 720, bg.normalMap, bg.texture)

local tileType = 0
function tablelength(T) local count = 0 for v in pairs(T) do count = count + 1 end return count end
local totalTiles = tablelength(level.map.texturesDiffuse) - 1

function moveUp(direction, deltaTime)
	p:moveIgnoreWall(0, -direction * p.speed * deltaTime)
	return true
end

function moveRight(direction, deltaTime)
	p:moveIgnoreWall(direction * p.speed * deltaTime, 0)
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

	local index = position.y * level.map.width + position.x
	local tile  = level.map.tiles[index + 1]

	if tile ~= tileType then
		level.map.tiles[index + 1] = tileType
		reloadTile(index, tileType)	
	end

end

function quit(direction, deltaTime)
	pop()
end

function update(deltatime)

	position = p:getPosition()
	bg:setPosition(position.x / 2 - (1280 / 2), position.y - (720 / 2))

	return true
end

function next(direction)

	if direction == 1 then
		tileType = tileType + 1
	elseif direction == -1 then
		tileType = tileType - 1
	end

	if tileType < 0 then
		tileType = 0
	end

	if tileType > totalTiles then
		tileType = totalTiles
	end

	print(tileType)
end

function save()
	print("Enter savename. Press 'Enter' to save")
	local name = io.read("*l")
	local fileDir = "Resources/Scripts/" .. name .. ".lua"

	local file = io.open(fileDir, "w")
	print("Open successful")
	
	--Name
	--file:write(name, " =\n{\n")
	file:write("tilemap1 =\n{\n")

	--Write texture diffuse
	file:write("\ttexturesDiffuse =\n\t{\n")
	for k, v in pairs(level.map.texturesDiffuse) do
		file:write("\t\t\"", level.map.texturesDiffuse[k], "\",\n")
	end
	file:write("\t},\n\n")

	--Write texture diffuse
	file:write("\ttexturesNormal =\n\t{\n")
	for k, v in pairs(level.map.texturesNormal) do
		file:write("\t\t\"", level.map.texturesNormal[k], "\",\n")
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

	
	file:write("\n\twidth = ", level.map.width, ",\n")
	file:write("\theight = ", level.map.height, "\n")
	file:write("}")

	io.close(file)
	print("Save successful")
end

function load()
	print("Enter filename. Press 'Enter' to load!")
	local name = io.read("*l")

	local fileDir = "Resources/Scripts/" .. name
	--.. ".lua"

	local file = require(fileDir)
	package.loaded[fileDir] = nil
	if file then
		print("Loading map!")
		clearTileMap()
		level:emptyMap()
		level = World:create()
		level:addMap(tilemap1)
		level:loadGraphics()
		p:addWorld(level)
		s:addWorld(level)
		print("Loading complete!")
	else
		print("Savefile not found!")
	end
end
