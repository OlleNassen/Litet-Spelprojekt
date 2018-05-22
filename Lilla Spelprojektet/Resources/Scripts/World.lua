World = {}
World.__index = World

function World:create()
    local this =
    {
		map = { }
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
	for i = 1, self.map.tilesets[1].tilecount, 1 do
		tTex(self.map.tilesets[1].tiles[i].image, self.map.tilesets[2].tiles[i].image)
	end
	--print(i)

	tGra(self.map.width)
	tGra(self.map.height)

	for i = 1, self.map.width * self.map.height, 1 do
		tGra(self.map.layers[1].data[i])
	end
end

function World:canMove(newX, newY)
		
	local x;
	local y;
			
	x = newX / self.map.tilewidth;
	y = newY / self.map.tileheight;

	x = math.floor(x + 1)
	y = math.floor(y)

	local id = self.map.layers[1].data[x + y * self.map.width]

	local result = true

	if self.map.tilesets[1].tiles[id] ~= nil then
		if id ~= 0 then
			result = self.map.tilesets[1].tiles[id].properties["ignore"]
		end
	end

	return result
end

function World:changeTile(type, x, y)
	index = x + y * self.map.width
	self.map.layers[1].data[index + 1] = type
	reloadTile(index, type)
end