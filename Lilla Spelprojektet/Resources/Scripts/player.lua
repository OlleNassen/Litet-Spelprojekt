--Todo: Finish

Player = {}
Player.__index = Player

function Player:create()
   local player = {}

   --Tile size:
	player.speed = 50;

   setmetatable(player,Player)

   return player
end

function Player:move()

end