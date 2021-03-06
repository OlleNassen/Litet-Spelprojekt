tilemap = require("Resources/Scripts/LuaStates/Map/Levels/Level2")
require("Resources/Scripts/common")

saveData(19, 2)

if loadData(0) == 0 then
	p.entity.x = 48 * 2
	p.entity.y = 48 * 16
	saveData(0, 0)
	p.entity.health = loadData(9)

elseif loadData(0) == 1 then 
	p.entity.x = 48 * 46
	p.entity.y = 48 * 3
	saveData(0, 0)
	p.entity.health = loadData(9)
end

local textureFunc = newTexture
local spriteFunc = newSprite

local level3Portal = Portal:create(48 * 48, 48 * 4)
local level1Portal = Portal:create(48 * 1, 48 * 17)

local color = 1

local light1 = PointLight:create(color, color, color, 10 * tileSize, tileSize * 9)

local light2 = PointLight:create(color, color, color, 24 * tileSize, tileSize)

local light3 = PointLight:create(color, color, color, tileSize, tileSize * 14)

local light4 = PointLight:create(color, color, color,tileSize * 39, tileSize)

local light5 = PointLight:create(color, color, color, tileSize * 2, tileSize * 36)

--Enemies
addEnemy(42 * 48, 48 * 9, 120, 120, level)
addEnemy(38 * 48, 48 * 9, 120, 120, level)
addEnemy(34 * 48, 48 * 9, 120, 120, level)
addEnemy(30 * 48, 48 * 9, 120, 120, level)
addEnemy(26 * 48, 48 * 9, 120, 120, level)

local power_laser 
if p.entity.hasPowerUp[5] == false then
	power_laser = Powerup:create("laser", 48 * 5, 48 * 5)
end

function update(deltaTime)
	checkUpgrades(deltaTime)

	s:setPosition(p.entity.x + mX, p.entity.y + mY)

	if level1Portal.entity:containsCollisionBox(p) then
		saveData(9, p.entity.health)
		savePowerup(p.entity.hasPowerUp)
		saveData(0, 1)
		newState("Resources/Scripts/LuaStates/Map/Level1State.lua")
	end	
	
	if level3Portal.entity:containsCollisionBox(p) then
		saveData(9, p.entity.health)
		savePowerup(p.entity.hasPowerUp)
		newState("Resources/Scripts/LuaStates/Map/Level3State.lua")
	end	

	updateEnemies(p, deltaTime)

	updateEntitys(deltaTime)

	p:update(deltaTime)

	updateBackground()
end

function updateEntitys(deltaTime)
	if p.entity.hasPowerUp[5] == false then
		if power_laser.entity:containsCollisionBox(p) then
			power_laser:activatePowerUp(p.entity)
			addLaserBar()
		end
		power_laser.entity:updateAnimation(deltaTime)
	end
end
