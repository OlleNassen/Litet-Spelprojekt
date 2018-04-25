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
	--print(i)

	loadTileGraphics(self.map.width)
	loadTileGraphics(self.map.height)
	
	for k, v in pairs(self.map.tiles) do
		loadTileGraphics(v)
	end
end

function World:emptyMap()
	self.map = {}
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
	
	if self.map.tiles[x + y * self.map.width] == 0 or 
		self.map.tiles[x + y * self.map.width] == 7 or 
		self.map.tiles[x + y * self.map.width] == 8 or 
		self.map.tiles[x + y * self.map.width] == 9 or
		self.map.tiles[x + y * self.map.width] == 10 then
		result = true		
	end

	return result
end