tilemap = require("Resources/Scripts/LuaStates/Map/Levels/Level6")
require("Resources/Scripts/common")

--Min 28x15 tiles
saveData(19, 6)
if loadData(0) == 0 then
	p.entity.x = 48 * 41
	p.entity.y = 48 * 19
	saveData(0, 0)
	p.entity.health = loadData(9)
elseif loadData(0) == 1 then
	p.entity.x = 48 * 2
	p.entity.y = 48 * 2
	saveData(0, 0)
	p.entity.health = loadData(9)
end

local health
if loadData(13) == 0 then
	health = Powerup:create("health", 48 * 24, 48 * 12)
end

local power_dash 
if p.entity.hasPowerUp[1] == false then
	power_dash = Powerup:create("dash", 48 * 4, 48 * 18)
end


local level3Portal = Portal:create(48 * 43, 48 * 21)
local level7Portal = Portal:create(48 * 1, 48 * 3)

local color = 1
local light1 = PointLight:create(color, color, color, 4 * tileSize, tileSize * 16)
local light2 = PointLight:create(color, color, color, 14 * tileSize, tileSize * 15)
local light3 = PointLight:create(color, color, color, 25 * tileSize, tileSize * 10)
local light4 = PointLight:create(color, color, color, 35 * tileSize, tileSize * 5)
local light5 = PointLight:create(color, color, color, 40 * tileSize, tileSize * 17)

local saws = {}
saws[1] = Saw:create(48 * 15, 48 * 22)
saws[2] = Saw:create(48 * 16, 48 * 22)
saws[3] = Saw:create(48 * 17, 48 * 22)
saws[4] = Saw:create(48 * 18, 48 * 22)
saws[5] = Saw:create(48 * 19, 48 * 22)
saws[6] = Saw:create(48 * 20, 48 * 22)
saws[7] = Saw:create(48 * 29, 48 * 22)
saws[8] = Saw:create(48 * 30, 48 * 22)
saws[9] = Saw:create(48 * 31, 48 * 22)
saws[10] = Saw:create(48 * 32, 48 * 22)
saws[11] = Saw:create(48 * 33, 48 * 22)
saws[12] = Saw:create(48 * 34, 48 * 22)

--Enemies
addEnemy(9 * 48, 48 * 13, 120, 120, level)
addEnemy(19 * 48, 48 * 13, 120, 120, level)

function update(deltaTime)
	checkUpgrades(deltaTime)

	s:setPosition(p.entity.x + mX, p.entity.y + mY)

	if level3Portal.entity:containsCollisionBox(p) then
		saveData(9, p.entity.health)
		savePowerup(p.entity.hasPowerUp)
		saveData(0, 4)
		newState("Resources/Scripts/LuaStates/Map/Level3State.lua")
	end

	if level7Portal.entity:containsCollisionBox(p) then
		saveData(9, p.entity.health)
		savePowerup(p.entity.hasPowerUp)
		saveData(0, 0)
		newState("Resources/Scripts/LuaStates/Map/Level7State.lua")
	end

	updateEnemies(p, deltaTime)

	updateEntitys(deltaTime)
	p:update(deltaTime)

	updateBackground()
end

function updateEntitys(deltaTime)
	for k, v in pairs(saws) do
		if v.entity:containsCollisionBox(p) then
			v:takeDamage(p)
		end
		v.entity:updateAnimation(deltaTime)
	end 

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

	if p.entity.hasPowerUp[1] == false then
		if power_dash.entity:containsCollisionBox(p) then
			power_dash:activatePowerUp(p.entity)
		end
		power_dash.entity:updateAnimation(deltaTime)
	end
end