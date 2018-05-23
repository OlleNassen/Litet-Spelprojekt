tilemap = require("Resources/Scripts/LuaStates/Map/Levels/Level7")
require("Resources/Scripts/common")

--Min 28x15 tiles
saveData(19, 7)
if loadData(0) == 0 then
	p.entity.x = 48 * 48
	p.entity.y = 48 * 19
	saveData(0, 0)
	p.entity.health = loadData(9)
elseif loadData(0) == 1 then
	p.entity.x = 48 * 48.5
	p.entity.y = 48 * 2
	saveData(0, 0)
	p.entity.health = loadData(9)
end

local health
if loadData(14) == 0 then
	health = Powerup:create("health", 48 * 48, 48 * 9)
end

local level6Portal = Portal:create(48 * 50, 48 * 20)
local levelBossPortal = Portal:create(48 * 50, 48 * 3)

local color = 1
local light1 = PointLight:create(color, color, color, 48 * tileSize, tileSize * 17)
local light2 = PointLight:create(color, color, color, 40 * tileSize, tileSize * 17)
local light3 = PointLight:create(color, color, color, 15 * tileSize, tileSize * 13)
local light4 = PointLight:create(color, color, color, 4 * tileSize, tileSize * 5)
local light5 = PointLight:create(color, color, color, 22 * tileSize, tileSize * 9)
local light6 = PointLight:create(color, color, color, 41 * tileSize, tileSize * 3)
local light6 = PointLight:create(color, color, color, 4 * tileSize, tileSize * 18)


--Enemies
addEnemy(20 * 48, 48 * 8, 120, 120, level)
addEnemy(22 * 48, 48 * 8, 120, 120, level)
addEnemy(2 * 48, 48 * 18, 120, 120, level)
addEnemy(12 * 48, 48 * 13, 120, 120, level)
addEnemy(18 * 48, 48 * 13, 120, 120, level)

function update(deltaTime)
	checkUpgrades(deltaTime)

	p:update(deltaTime)
	s:setPosition(p.entity.x + mX, p.entity.y + mY)

	if level6Portal.entity:containsCollisionBox(p) then
		saveData(9, p.entity.health)
		savePowerup(p.entity.hasPowerUp)
		saveData(0, 1)
		newState("Resources/Scripts/LuaStates/Map/Level6State.lua")
	end

	if levelBossPortal.entity:containsCollisionBox(p) then
		saveData(9, p.entity.health)
		savePowerup(p.entity.hasPowerUp)
		saveData(0, 0)
		newState("Resources/Scripts/LuaStates/Map/LevelBossState.lua")
	end

	updateEnemies(p, deltaTime)

	updateEntitys(deltaTime)

	updateBackground()
end

function updateEntitys(deltaTime)
	if loadData(14) == 0 then
		if health.entity:containsCollisionBox(p) then
			if health.aquired == false then
				saveData(14, 1)
				p:healPlayer(20)
				health:disablePowerup()
			end
		end
		health.entity:updateAnimation(deltaTime)
	end
end