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
	
	local tTex = tileTexture
	local tGra = loadTileGraphics
	
	local i = 1
	for k, v in pairs(self.map.texturesDiffuse) do
		tTex(v, self.map.texturesNormal[i])
		i = i + 1
	end
	--print(i)

	tGra(self.map.width)
	tGra(self.map.height)
	
	for k, v in pairs(self.map.tiles) do
		tGra(v)
	end
end

function World:emptyMap()
	self.map = {}
	clearTileMap()
end

function World:canMove(newX, newY)
		
	local x;
	local y;
			
	x = newX / self.tileSize;
	y = newY / self.tileSize;

	x = math.floor(x + 1)
	y = math.floor(y)
	
	local result = self.map.ignore[self.map.tiles[x + y * self.map.width] + 1]

	return result
end