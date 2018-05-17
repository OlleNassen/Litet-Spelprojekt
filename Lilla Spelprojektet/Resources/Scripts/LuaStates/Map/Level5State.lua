tilemap = require("Resources/Scripts/LuaStates/Map/Levels/Level5")
require("Resources/Scripts/common")

--Min 28x15 tiles

if loadData(0) == 0 then
	p.entity.x = 48 * 1
	p.entity.y = 48 * 13
	saveData(0, 0)
elseif loadData(0) == 1 then
	p.entity.x = 48 * 2
	p.entity.y = 48 * 1
	saveData(0, 0)
end

local level2PortalTop = Portal:create(48 * 1, 48 * 2)
local level2PortalBottom = Portal:create(48 * 1, 48 * 14)

local color = 1
local light1 = PointLight:create(color, color, color, 8 * tileSize, tileSize * 2)
local light2 = PointLight:create(color, color, color, 11 * tileSize, tileSize * 11)
local light3 = PointLight:create(color, color, color, 23 * tileSize, tileSize * 11)
local light4 = PointLight:create(color, color, color, 26 * tileSize, tileSize * 2)

--Enemies
addEnemy(9 * 48, 48 * 13, 120, 120, level)
addEnemy(19 * 48, 48 * 13, 120, 120, level)

function update(deltaTime)
	checkUpgrades(deltaTime)

	p:update(deltaTime)
	s:setPosition(p.entity.x + mX, p.entity.y + mY)

	if level2PortalTop.entity:containsCollisionBox(p) then
		savePowerup(p.entity.hasPowerUp)
		saveData(0, 3)
		newState("Resources/Scripts/LuaStates/Map/Level3State.lua")
	end

	if level2PortalBottom.entity:containsCollisionBox(p) then
		savePowerup(p.entity.hasPowerUp)
		saveData(0, 2)
		newState("Resources/Scripts/LuaStates/Map/Level3State.lua")
	end

	updateEnemies(p, deltaTime)

	updateBackground()
end

function updateEntitys(deltaTime)
	
end