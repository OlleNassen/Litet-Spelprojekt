tilemap = require("Resources/Scripts/LuaStates/Map/Levels/Level0")
require("Resources/Scripts/common")

--Min 28x15 tiles

if loadData(0) == 0 then
	p.entity.x = 48 * 1
	p.entity.y = 48 * 1
	saveData(0, 0)

elseif loadData(0) == 1 then 
	p.entity.x = 48 * 26
	p.entity.y = 48 * 5
	saveData(0, 0)
end

local level1Portal = Portal:create(48 * 98, 48 * 33)

local color = 1

local light1 = PointLight:create(color, color, color, 3 * tileSize, tileSize * 2)
local light2 = PointLight:create(color, color, color, 24 * tileSize, tileSize * 4)
local light3 = PointLight:create(color, color, color, 48 * tileSize, tileSize * 8)
local light4 = PointLight:create(color, color, color, 42 * tileSize, tileSize * 21)
local light5 = PointLight:create(color, color, color, 28 * tileSize, tileSize * 25)
local light6 = PointLight:create(color, color, color, 11 * tileSize, tileSize * 24)
local light7= PointLight:create(color, color, color, 8 * tileSize, tileSize * 42)
local light8 = PointLight:create(color, color, color, 32 * tileSize, tileSize * 35)
local light9 = PointLight:create(color, color, color, 47 * tileSize, tileSize * 39)
local light10 = PointLight:create(color, color, color, 69 * tileSize, tileSize * 40)

function update(deltaTime)
	checkUpgrades(deltaTime)

	p:update(deltaTime)
	s:setPosition(p.entity.x + mX, p.entity.y + mY)

	if level1Portal.entity:containsCollisionBox(p) then
		savePowerup(p.entity.hasPowerUp)
		newState("Resources/Scripts/LuaStates/Map/Level1State.lua")
	end

	updateEntitys(deltaTime)

	updateBackground()
end

function updateEntitys(deltaTime)

end