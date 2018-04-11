World = {}
World.__index = World

function World:create()
    local this =
    {
		map = {1,1,1,1,1,1},
		entities = { },
		tileSize = 48,
		entityCount = 0
    }

    setmetatable(this, self)
    return this
end

function World:addMap(map)
	self.map = map
end

function World:addEntity(entity)
	self.entityCount = self.entityCount + 1
	self.entities[self.entityCount] = entity
end

function World:loadGraphics()
	
	loadTileGraphics(self.map.width)
	loadTileGraphics(self.map.height)
	
	for k, v in pairs(self.map.tiles) do
		loadTileGraphics(v)
	end
	
	
end

function World:update(deltaTime)
	--[[
	for id = 1, entityCount do

		local x;
		local y;
			
		x = entities[id].x / tileSize;
		y = entities[id + 1].y / tileSize;

		if tileList[x + y * width] == 0 and tileList[(x + 1) + (y + 1) * width] == 0 then
		{
			entities[id + 1].x = entities[id].x;
		end

		x = entities[id + 1].x / tileSize;
		y = entities[id].y / tileSize;

		if tileList[x + y * width] == 0 and tileList[(x + 1) + (y + 1) * width] == 0 then
			entities[id + 1].y = entities[id].y;
		end
		
		x = entities[id].x / tileSize;
		y = entities[id].y / tileSize;
		
		if tileList[x + y * width] == 0 and tileList[(x+1) + (y+1) * width] == 0 then
			entities[id + 1] = entities[id];
		else
			entities[id] = entities[id + 1];
		end
	end
	 --]]
end