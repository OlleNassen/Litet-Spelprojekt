--Todo: Finish

Player = {}
Player.__index = Player

function Player:create(x, y)
   local player = {}

   --Tile size:
   player.position = position.new()
   position.setPosition(player.position, x, y) 
   player.speed = 50
   player.attackStrength = 5
   player.attackSpeed = 1

   setmetatable(player,Player)

   return player
end

function Player:move(x, y)
	position.move(self.position, x, y)
end