require("Resources/Scripts/LuaStates/Map/Levels/Level2")
require("Resources/Scripts/common")
newMusic("Resources/Sound/canary.wav")

local textureFunc = newTexture
local spriteFunc = newSprite

local level3Portal = Portal:create(48 * 47, 48 * 4)

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


local saws = {}
saws[1] = Saw:create(48 * 2, 48 * 3)
saws[2] = Saw:create(48 * 3, 48 * 3)
saws[3] = Saw:create(48 * 4, 48 * 3)

local power_health = Powerup:create("health", 400, 500) -- GIVES HEALTH
local power_speed = Powerup:create("speed", 450, 500) -- GIVES SPEED INCREASE

function update(deltaTime)
	checkUpgrades(deltaTime)

	p:update(deltaTime)
	s:setPosition(p.entity.x + mX, p.entity.y + mY)

	
	if level3Portal.entity:containsCollisionBox(p) then
		savePowerup(p.entity.hasPowerUp)
		newState("Resources/Scripts/LuaStates/Map/Level3State.lua")
	end	

	updateEnemies(p, deltaTime)

	updateEntitys(deltaTime)

	updateBackground()
end

function updateEntitys(deltaTime)
	if power_health.entity:containsCollisionBox(p) then
		if power_health.aquired == false then
			p:healPlayer(20)
			power_health:disablePowerup()
		end
	end
	power_health.entity:updateAnimation(deltaTime)

	if power_speed.entity:containsCollisionBox(p) then
		power_speed:activatePowerUp(p.entity)
	end

	power_speed.entity:updateAnimation(deltaTime)
	for k, v in pairs(saws) do
		if v.entity:containsCollisionBox(p) then
			v:takeDamage(p)
		end
		v.entity:updateAnimation(deltaTime)
	end 
end
