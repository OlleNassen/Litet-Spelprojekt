--You can use this as template for other lua classes

--Todo: Add type

Tile = {}
Tile.__index = Tile

function Tile:create(position)
   local tile = {}

   tile.x = position.x
   tile.y = position.y
   
   --Tile size:
	tile.width = 48
	tile.height = 48

   setmetatable(tile,Tile)

   return tile
end

function Tile:getPosition()
   return self.x, self.y
end

function Tile:getSize()
   return self.width, self.height
end

function Tile:print()
	print(self.width, self.height)
end