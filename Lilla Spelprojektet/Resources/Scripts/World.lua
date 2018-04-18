World = {}
World.__index = World

function World:create()
    local this =
    {
		map = { },
		tileSize = 48,
    }

    setmetatable(this, self)
    return this
end

function World:addMap(map)
	self.map = map
end

function World:loadGraphics()
	
	local i = 1
	for k, v in pairs(self.map.texturesDiffuse) do
		tileTexture(v, self.map.texturesNormal[i])
		i = i + 1
	end

	loadTileGraphics(self.map.width)
	loadTileGraphics(self.map.height)
	
	for k, v in pairs(self.map.tiles) do
		loadTileGraphics(v)
	end
end

function World:emptyMap()
	clearTileMap()
end

function World:canMove(newX, newY)
	
	local result = false
	
	local x;
	local y;
			
	x = newX / self.tileSize;
	y = newY / self.tileSize;

	x = math.floor(x + 1)
	y = math.floor(y)
	
	if self.map.tiles[x + y * self.map.width] == 0 then
		result = true		
	end

	return result
end