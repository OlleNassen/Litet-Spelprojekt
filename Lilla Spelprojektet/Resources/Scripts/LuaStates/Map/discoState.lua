
tilemap = require("Resources/Scripts/LuaStates/Map/Levels/disco")
require("Resources/Scripts/common")


--Min 28x15 tiles

if loadData(0) == 0 then
	p.entity.x = 48 * 2
	p.entity.y = 48 * 10
	saveData(0, 0)

elseif loadData(0) == 1 then 
	p.entity.x = 48 * 26
	p.entity.y = 48 * 5
	saveData(0, 0)
end

local level2Portal = Portal:create(48 * 28, 48 * 6)

local color = 1

local light1 = PointLight:create(color, color, color, 3 * tileSize, tileSize * 1)

local light2 = PointLight:create(color, color, color, 6 * tileSize, tileSize * 16)

local light3 = PointLight:create(color, color, color, 13 * tileSize, tileSize * 10)

local light4 = PointLight:create(color, color, color, 26 * tileSize, tileSize * 4)

function update(deltaTime)
	checkUpgrades(deltaTime)

	p:update(deltaTime)
	s:setPosition(p.entity.x + mX, p.entity.y + mY)

	if level2Portal.entity:containsCollisionBox(p) then
		savePowerup(p.entity.hasPowerUp)
		newState("Resources/Scripts/LuaStates/Map/Level2State.lua")
	end

	updateEntitys(deltaTime)

	updateBackground()
end

function updateEntitys(deltaTime)

end