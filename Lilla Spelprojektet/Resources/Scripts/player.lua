--Todo: Finish

require("/Resources/Scripts/powerup")

Player = {}
Player.__index = Player

function Player:create()
   local player = {}

   --Tile size:
	player.speed = 50
	player.attackStrength = 5
	player.attackSpeed = 1

   setmetatable(player,Player)

   return player
end

function Player:move()

end