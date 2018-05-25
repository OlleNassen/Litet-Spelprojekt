tilemap = require("Resources/Scripts/LuaStates/Map/Levels/Level5")
require("Resources/Scripts/common")

--Min 28x15 tiles
saveData(19, 5)
if loadData(0) == 0 then
	p.entity.x = 48 * 1
	p.entity.y = 48 * 13
	saveData(0, 0)
	p.entity.health = loadData(9)

elseif loadData(0) == 1 then
	p.entity.x = 48 * 2
	p.entity.y = 48 * 1
	saveData(0, 0)
	p.entity.health = loadData(9)
end

local health
if loadData(11) == 0 then
	health = Powerup:create("health", 48 * 32.5, 48 * 9)
end

local level2PortalTop = Portal:create(48 * 1, 48 * 2)
local level2PortalBottom = Portal:create(48 * 1, 48 * 14)

local color = 1
local light1 = PointLight:create(color, color, color, 8 * tileSize, tileSize * 2)
local light2 = PointLight:create(color, color, color, 11 * tileSize, tileSize * 11)
local light3 = PointLight:create(color, color, color, 23 * tileSize, tileSize * 11)
local light4 = PointLight:create(color, color, color, 26 * tileSize, tileSize * 2)
local light5 = PointLight:create(color, color, color, 34 * tileSize, tileSize * 8)

--Enemies
addEnemy(9 * 48, 48 * 13, 120, 120, level)
addEnemy(19 * 48, 48 * 13, 120, 120, level)

function update(deltaTime)
	checkUpgrades(deltaTime)

	s:setPosition(p.entity.x + mX, p.entity.y + mY)

	if level2PortalTop.entity:containsCollisionBox(p) then
		saveData(9, p.entity.health)
		savePowerup(p.entity.hasPowerUp)
		saveData(0, 3)
		newState("Resources/Scripts/LuaStates/Map/Level3State.lua")
	end

	if level2PortalBottom.entity:containsCollisionBox(p) then
		saveData(9, p.entity.health)
		savePowerup(p.entity.hasPowerUp)
		saveData(0, 2)
		newState("Resources/Scripts/LuaStates/Map/Level3State.lua")
	end

	updateEnemies(p, deltaTime)

	updateEntitys(deltaTime)
	p:update(deltaTime)

	updateBackground()
end

function updateEntitys(deltaTime)
	if loadData(11) == 0 then
		if health.entity:containsCollisionBox(p) then
			if health.aquired == false then
				saveData(11, 1)
				p:healPlayer(20)
				health:disablePowerup()
			end
		end
		health.entity:updateAnimation(deltaTime)
	end
end