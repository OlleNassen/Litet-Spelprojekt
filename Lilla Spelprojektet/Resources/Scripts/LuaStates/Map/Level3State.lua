
require("Resources/Scripts/LuaStates/Map/Levels/Level3")
require("Resources/Scripts/common")
m = newMusic("Resources/Sound/canary.wav")

--Min 28x15 tiles

if loadData(0) == 0 then
	p.entity.x = 48 * 1.5
	p.entity.y = 48 * 35
	saveData(0, 0)

elseif loadData(0) == 1 then 
	p.entity.x = 48 * 25.5
	p.entity.y = 48 * 35
	saveData(0, 0)

elseif loadData(0) == 2 then 
	p.entity.x = 48 * 44
	p.entity.y = 48 * 3
	saveData(0, 0)
end

local level2Portal = Portal:create(48 * 1, 48 * 36)
local level3Portal = Portal:create(48 * 26, 48 * 36)

local saws = {}
saws[1] = Saw:create(48 * 8, 48 * 37)
saws[2] = Saw:create(48 * 9, 48 * 37)
saws[3] = Saw:create(48 * 10, 48 * 37)
saws[4] = Saw:create(48 * 11, 48 * 37)
saws[5] = Saw:create(48 * 12, 48 * 37)
saws[6] = Saw:create(48 * 13, 48 * 37)
saws[7] = Saw:create(48 * 14, 48 * 37)
saws[8] = Saw:create(48 * 15, 48 * 37)
saws[9] = Saw:create(48 * 16, 48 * 37)
saws[10] = Saw:create(48 * 17, 48 * 37)
saws[11] = Saw:create(48 * 18, 48 * 37)
saws[12] = Saw:create(48 * 19, 48 * 37)

local color = 1
local light1 = PointLight:create(color, color, color, 3 * tileSize, tileSize * 32)
local light2 = PointLight:create(color, color, color, 24 * tileSize, tileSize * 32)
local light3 = PointLight:create(color, color, color, 13.5 * tileSize, tileSize * 31)

function update(deltaTime)
	checkUpgrades(deltaTime)

	p:update(deltaTime)
	s:setPosition(p.entity.x + mX, p.entity.y + mY)

	if level2Portal.entity:containsCollisionBox(p) then
		savePowerup(p.entity.hasPowerUp)
		saveData(0, 1)
		newState("Resources/Scripts/LuaStates/Map/Level2State.lua")
	end

	if level3Portal.entity:containsCollisionBox(p) then
		savePowerup(p.entity.hasPowerUp)
		saveData(0, 0)
		newState("Resources/Scripts/LuaStates/Map/Level3State.lua")
	end

	updateEntitys(deltaTime)

	updateBackground()
end

function updateEntitys(deltaTime)
	for k, v in pairs(saws) do
		if v.entity:containsCollisionBox(p) then
			v:takeDamage(p)
		end
		v.entity:updateAnimation(deltaTime)
	end 
end