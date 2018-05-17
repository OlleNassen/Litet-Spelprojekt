tilemap = require("Resources/Scripts/LuaStates/Map/Levels/Level2")
require("Resources/Scripts/common")
newMusic("Resources/Sound/canary.wav")

local textureFunc = newTexture
local spriteFunc = newSprite

local level3Portal = Portal:create(48 * 47, 48 * 4)
local discoPortal = Portal:create(48 * 47, 48 * 17)

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

function update(deltaTime)
	checkUpgrades(deltaTime)

	p:update(deltaTime)
	s:setPosition(p.entity.x + mX, p.entity.y + mY)

	
	if level3Portal.entity:containsCollisionBox(p) then
		savePowerup(p.entity.hasPowerUp)
		newState("Resources/Scripts/LuaStates/Map/Level3State.lua")
	end	

	if discoPortal.entity:containsCollisionBox(p) then
		savePowerup(p.entity.hasPowerUp)
		newState("Resources/Scripts/LuaStates/Map/discoState.lua")
	end	

	updateEnemies(p, deltaTime)

	updateEntitys(deltaTime)

	updateBackground()
end

function updateEntitys(deltaTime)
	
end
