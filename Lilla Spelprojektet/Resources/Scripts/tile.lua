--You can use this as template for other lua classes

--Todo: Add type

Tile = {}
Tile.__index = Tile

function Tile:create(position)
   local tile = {}
   setmetatable(tile,Tile)
   tile.x = position.x
   tile.y = position.y
   
   --Tile size:
	tile.width = 48
	tile.height = 48
   return tile
end

function Tile:getSize()
   return self.width, self.height
end