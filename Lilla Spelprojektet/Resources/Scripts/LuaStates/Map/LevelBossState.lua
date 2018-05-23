tilemap = require("Resources/Scripts/LuaStates/Map/Levels/LevelBoss")
require("Resources/Scripts/common")
require("Resources/Scripts/boss")

local textureFunc = newTexture
local spriteFunc = newSprite

--Min 28x15 tiles
saveData(19,8055)
if loadData(0) == 0 then
	p.entity.x = 48 * 1.5
	p.entity.y = 48 * 7
	saveData(0, 0)
	p.entity.health = loadData(9)
end

local health
if loadData(15) == 0 then
	health = Powerup:create("health", 48 * 2, 48 * 2)
end

local b = Boss:create(48 * 27.5, 48 * 3.8, 300, 300)
b.entity:addWorld(level)

local level7Portal = Portal:create(48 * 1, 48 * 8)

local levelWinPortal = Portal:create(48 * 50, 48 * 10)

b.spriteBossHPBarBack = spriteFunc(-400, 40, 0, b.textureBossHPBarBack)
spritePos(b.spriteBossHPBarBack, 1270, 20)
b.spriteBossHPBar = spriteFunc(-400, 25, 0, b.textureBossHPBar)
spritePos(b.spriteBossHPBar, 1270, 27.5)

local color = 1
local light1 = PointLight:create(color, color, color, 5 * tileSize, tileSize * 5)
local light2 = PointLight:create(color, color, color, 14 * tileSize, tileSize * 5)
local light3 = PointLight:create(color, color, color, 22 * tileSize, tileSize * 5)
local light4 = PointLight:create(color, color, color, 35 * tileSize, tileSize * 5)

local bossDefeated = false

function update(deltaTime)
	checkUpgrades(deltaTime)

	p:update(deltaTime)
	b:update(deltaTime,p)
	s:setPosition(p.entity.x + mX, p.entity.y + mY)

	if level7Portal.entity:containsCollisionBox(p) then
		saveData(9, p.entity.health)
		savePowerup(p.entity.hasPowerUp)
		saveData(0, 1)
		newState("Resources/Scripts/LuaStates/Map/Level7State.lua")
	end

	if b.entity.health <= 0 and bossDefeated == false then
		levelWinPortal.entity:setPosition(48 * 37, 48 * 10)
		level:changeTile(0, 33, 4)
		level:changeTile(0, 33, 5)
		level:changeTile(0, 33, 6)
		level:changeTile(0, 33, 7)
		level:changeTile(0, 33, 8)
		level:changeTile(0, 33, 9)
		b.entity:setPosition(10000, 10000)
		bossDefeated = true
	end

	if levelWinPortal.entity:containsCollisionBox(p) then
		saveData(9, p.entity.health)
		savePowerup(p.entity.hasPowerUp)
		saveData(0, 1)
		newState("Resources/Scripts/LuaStates/victoryState.lua")
	end

	--updateEnemies(p, deltaTime)

	updateEntitys(deltaTime)

	updateBackground()

	if p.entity.y >= level.map.height * tileSize + 500 then
		p:reset()
		newState("Resources/Scripts/LuaStates/gameOverState.lua")
	end
end

function updateEntitys(deltaTime)
	if loadData(15) == 0 then
		if health.entity:containsCollisionBox(p) then
			if health.aquired == false then
				saveData(15, 1)
				p:healPlayer(20)
				health:disablePowerup()
			end
		end
		health.entity:updateAnimation(deltaTime)
	end
end