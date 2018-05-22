tilemap = require("Resources/Scripts/LuaStates/Map/Levels/LevelBoss")
require("Resources/Scripts/common")

--Min 28x15 tiles

if loadData(0) == 0 then
	p.entity.x = 48 * 2.5
	p.entity.y = 48 * 7
	saveData(0, 0)
	p.entity.health = loadData(9)
end

local health
if loadData(13) == 0 then
	health = Powerup:create("health", 48 * 2, 48 * 2)
end

local level7Portal = Portal:create(48 * 1, 48 * 8)

local color = 1
local light1 = PointLight:create(color, color, color, 5 * tileSize, tileSize * 5)
local light2 = PointLight:create(color, color, color, 14 * tileSize, tileSize * 5)
local light3 = PointLight:create(color, color, color, 22 * tileSize, tileSize * 5)
local light4 = PointLight:create(color, color, color, 35 * tileSize, tileSize * 5)


function update(deltaTime)
	checkUpgrades(deltaTime)

	p:update(deltaTime)
	s:setPosition(p.entity.x + mX, p.entity.y + mY)

	if level7Portal.entity:containsCollisionBox(p) then
		saveData(9, p.entity.health)
		savePowerup(p.entity.hasPowerUp)
		saveData(0, 1)
		newState("Resources/Scripts/LuaStates/Map/Level7State.lua")
	end

	--updateEnemies(p, deltaTime)

	updateEntitys(deltaTime)

	updateBackground()

	if p.entity.y >= level.map.height * tileSize + 500 then
		newState("Resources/Scripts/LuaStates/gameOverState.lua")
	end
end

function updateEntitys(deltaTime)
	if loadData(13) == 0 then
		if health.entity:containsCollisionBox(p) then
			if health.aquired == false then
				saveData(13, 1)
				p:healPlayer(20)
				health:disablePowerup()
			end
		end
		health.entity:updateAnimation(deltaTime)
	end
end