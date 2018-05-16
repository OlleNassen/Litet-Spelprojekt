require("Resources/Scripts/Entity")
require("Resources/Scripts/background")
require("Resources/Scripts/player")
require("Resources/Scripts/ai")
require("Resources/Scripts/World")
require("Resources/Scripts/olleTilemap")
require("Resources/Scripts/powerup")
require("Resources/Scripts/point_light")
require("Resources/Scripts/save")
require("Resources/Scripts/enemyContainer")

local textureFunc = newTexture
local spriteFunc = newSprite

local level = World:create()
level:addMap(olleTilemap)
level:loadGraphics()

-- PowerUps
-- Dash
towardsX = 0
towardsY = 0
hasFoundPosition = false

p = Player:create() -- player
p.entity.x = 48
p.entity.y = 48
p.entity:addWorld(level)


local s = Entity:create() -- pixie
s.x = 200
s.y = 100
s.maxSpeed.x = 200
s.maxSpeed.y = 200
s.normalMap = textureFunc("Resources/Sprites/player.png")
s.texture = textureFunc("Resources/Sprites/player.png")
s.sprite = spriteFunc(s.normalMap, s.texture)
s:addWorld(level)

local nextPortal = Entity:create()
nextPortal.offsetX = 12
nextPortal.collision_width = 24
nextPortal.collision_height = 96
nextPortal.texture = textureFunc("Resources/Sprites/door_diffuse.png")
nextPortal.normalMap = textureFunc("Resources/Sprites/door_normal.png")
nextPortal.sprite = spriteFunc(nextPortal.normalMap, nextPortal.texture)
nextPortal:setSize(48, 96)
nextPortal:addWorld(level)
nextPortal:setPosition(48 * 24, 48)

p.spriteHPBar = spriteFunc(500, 50, 0, p.textureHPBar)
spritePos(p.spriteHPBar, 50, 50)
p.spriteHPBarBack = spriteFunc(500, 50, 0, p.textureHPBarBack)
spritePos(p.spriteHPBarBack, 50, 50)

tileSize = 48

--Lights
local color = 1

local light1 = PointLight:create(color, color, color, 2 * tileSize, tileSize,
"Resources/Sprites/lamp_normal.png",
"Resources/Sprites/lamp_diffuse.png")

local light2 = PointLight:create(color, color, color, 4 * tileSize, tileSize * 20,
"Resources/Sprites/lamp_normal.png",
"Resources/Sprites/lamp_diffuse.png")

local light3 = PointLight:create(color, color, color, tileSize * 9, tileSize * 10,
"Resources/Sprites/lamp_normal.png",
"Resources/Sprites/lamp_diffuse.png")

local light4 = PointLight:create(color, color, color,tileSize * 22, tileSize,
"Resources/Sprites/lamp_normal.png",
"Resources/Sprites/lamp_diffuse.png")

local light5 = PointLight:create(color, color, color, tileSize * 19, tileSize * 20,
"Resources/Sprites/lamp_normal.png",
"Resources/Sprites/lamp_diffuse.png")

--Powerups
local power_jump = Powerup:create("doubleJump", 430, 580) -- GIVES HEALTH

--Enemies
addEnemy(48,36 * 48, 120, 120, level)
addEnemy(48 * 2,36 * 48, 120, 120, level)
addEnemy(1000,1000, 120, 120, level)
addEnemy(1000,1000, 120, 120, level)
addEnemy(1000,1000, 120, 120, level)
addEnemy(1000,1000, 120, 120, level)
addEnemy(1000,1000, 120, 120, level)
addEnemy(1000,1000, 120, 120, level)
addEnemy(1000,1000, 120, 120, level)

--Boss
local b = Ai:create(1500, 100, 500, 500)
b.entity:addWorld(level)

local bgs = {}

bgs[1] = Background:create()
bgs[1].texture = textureFunc("Resources/Sprites/Background/Pillar_diffuse_48.png")
bgs[1].sprite = newBackground(50, 1200, 0, bgs[1].texture)

bgs[2] = Background:create()
bgs[2].sprite = newBackground(50, 1200, 0, bgs[1].texture)

bgs[3] = Background:create()
bgs[3].sprite = newBackground(50, 1200, 0, bgs[1].texture)

local totalFurthestSprites = 3

bgs[4] = Background:create()
bgs[4].texture = textureFunc("Resources/Sprites/Background/Pillar_diffuse.png")
bgs[4].sprite = newBackground(100, 1600, 0, bgs[4].texture)

bgs[5] = Background:create()
bgs[5].sprite = newBackground(100, 1600, 0, bgs[4].texture)

bgs[6] = Background:create()
bgs[6].sprite = newBackground(100, 1600, 0, bgs[4].texture)--[[]]

--Initialize inputs and player
require("Resources/Scripts/playerInput")

function update(deltaTime)
	
	--Update upgrades
	checkUpgrades(deltaTime)

	--Update player
	p:update(deltaTime)

	--Update pixie
	s:setPosition(p.entity.x + mX, p.entity.y + mY)

	--Update portals
	if nextPortal:containsCollisionBox(p) then
		savePowerup(p.entity.hasPowerUp)
		newState("Resources/Scripts/LuaStates/gameState.lua")
	end

	--Update powerups
	power_jump:contains(p.entity)
	power_jump.entity:updateAnimation(deltaTime)
	
	--Update enemies
	updateEnemies(p, deltaTime)
	
	--Update boss
	b:attack(p)
	
	--Update background
	pX, pY = getCameraPosition()	
	for k, v in pairs(bgs) do
		if k <= totalFurthestSprites then
			v:setPosition(pX * 0.01  + (600 * k), pY * -0.05 - 100, k)
		else
			index = k - totalFurthestSprites
			v:setPosition(pX * 0.1 + (index * 800), pY * -0.2, k)
		end
	end
end

