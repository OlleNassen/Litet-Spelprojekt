tilemap = require("Resources/Scripts/LuaStates/Map/Levels/Level0")
require("Resources/Scripts/common")

--Min 28x15 tiles
saveData(19, 19)

if loadData(0) == 0 then
	p.entity.x = 48 * 1
	p.entity.y = 48 * 1
	saveData(0, 0)

elseif loadData(0) == 1 then 
	p.entity.x = 48 * 26
	p.entity.y = 48 * 5
	saveData(0, 0)
end

local level1Portal = Portal:create(48 * 58, 48 * 36)

local color = 1

local light1 = PointLight:create(color, color, color, 3 * tileSize, tileSize * 2)
local light2 = PointLight:create(color, color, color, 31 * tileSize, tileSize * 5)
local light3 = PointLight:create(color, color, color, 55 * tileSize, tileSize * 8)
local light4 = PointLight:create(color, color, color, 41 * tileSize, tileSize * 21)
local light5 = PointLight:create(color, color, color, 20 * tileSize, tileSize * 24)
local light6 = PointLight:create(color, color, color, 5 * tileSize, tileSize * 45)
local light7= PointLight:create(color, color, color, 28 * tileSize, tileSize * 40)
local light8 = PointLight:create(color, color, color, 43 * tileSize, tileSize * 40)
local light9 = PointLight:create(color, color, color, 57 * tileSize, tileSize * 40)

--Enemies
addEnemy(30 * 48, 48 * 6, 120, 120, level)
addEnemy(28 * 48, 48 * 25, 120, 120, level)
addEnemy(6 * 48, 48 * 46, 120, 120, level)
addEnemy(32 * 48, 48 * 45, 120, 120, level)

--Health
local health = Powerup:create("health", 48 * 1, 48 * 46.5)

function update(deltaTime)
	checkUpgrades(deltaTime)

	p:update(deltaTime)
	s:setPosition(p.entity.x + mX, p.entity.y + mY)

	if level1Portal.entity:containsCollisionBox(p) then
		savePowerup(p.entity.hasPowerUp)
		saveData(9, p.entity.health)
		newState("Resources/Scripts/LuaStates/Map/Level1State.lua")
	end

	updateEntitys(deltaTime)

	updateEnemies(p, deltaTime)

	updateBackground()
end

function updateEntitys(deltaTime)
	if health.entity:containsCollisionBox(p) then
			if health.aquired == false then
				p:healPlayer(20)
				health:disablePowerup()
			end
	end
	health.entity:updateAnimation(deltaTime)
end