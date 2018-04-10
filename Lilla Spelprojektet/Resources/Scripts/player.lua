--Todo: Finish

require("/Resources/Scripts/powerup")

Player = {}
Player.__index = Player

function Player:create(position)
   local player = {}

   --Tile size:
   player.position = position
   player.speed = 50
   player.attackStrength = 5
   player.attackSpeed = 1

   setmetatable(player,Player)

   return player
end

function Player:move(position)
	self.position = self.position + position
end