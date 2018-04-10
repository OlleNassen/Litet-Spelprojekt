Goomba = {}
Goomba.__index = Goomba

function Goomba:create(position)
   local goomba = {}

   --Tile size:
   goomba.position = position
   goomba.speed = 50
   goomba.attackStrength = 5
   goomba.attackSpeed = 1

   setmetatable(goomba,Goomba)

   return goomba
end

function Goomba:move(position)
	self.position = self.position + position
end