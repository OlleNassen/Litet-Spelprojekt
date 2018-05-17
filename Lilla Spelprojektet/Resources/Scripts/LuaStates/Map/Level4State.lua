tilemap = require("Resources/Scripts/LuaStates/Map/Levels/Level4")
require("Resources/Scripts/common")
m = newMusic("Resources/Sound/canary.wav")

--Min 28x15 tiles

if loadData(0) == 0 then
	p.entity.x = 48 * 2
	p.entity.y = 48 * 1
	saveData(0, 0)
end

local level3Portal = Portal:create(48 * 1, 48 * 2)

local color = 1
local light1 = PointLight:create(color, color, color, 4 * tileSize, tileSize * 5)
local light2 = PointLight:create(color, color, color, 4 * tileSize, tileSize * 11)
local light3 = PointLight:create(color, color, color, 16 * tileSize, tileSize * 10)
local light4 = PointLight:create(color, color, color, 27 * tileSize, tileSize * 10)

--Enemies
addEnemy(19 * 48, 48 * 15, 120, 120, level)
addEnemy(24 * 48, 48 * 15, 120, 120, level)

local power_highJump
if p.entity.hasPowerUp[4] == false then
	power_highJump = Powerup:create("highJump", 48 * 29.5, 48 * 13.5)
end

function update(deltaTime)
	checkUpgrades(deltaTime)

	p:update(deltaTime)
	s:setPosition(p.entity.x + mX, p.entity.y + mY)

	if level3Portal.entity:containsCollisionBox(p) then
		savePowerup(p.entity.hasPowerUp)
		saveData(0, 1)
		newState("Resources/Scripts/LuaStates/Map/Level3State.lua")
	end

	updateEnemies(p, deltaTime)

	updateEntitys(deltaTime)

	updateBackground()
end

function updateEntitys(deltaTime)
	if p.entity.hasPowerUp[4] == false then
		if power_highJump.entity:containsCollisionBox(p) then
			power_highJump:activatePowerUp(p.entity)
		end
		power_highJump.entity:updateAnimation(deltaTime)
	end
end