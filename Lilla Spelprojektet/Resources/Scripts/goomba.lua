Goomba = {}
Goomba.__index = Goomba

function Goomba:create(x, y)
   local goomba = {}

   --Tile size:
   goomba.position = position.new()
   position.setPosition(goomba.position, x, y) 
   goomba.speed = 50
   goomba.attackStrength = 5
   goomba.attackSpeed = 1

   setmetatable(goomba,Goomba)

   return goomba
end

function Goomba:move(x, y)
	position.move(self.position, x, y)
end