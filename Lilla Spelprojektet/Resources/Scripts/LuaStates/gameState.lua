require("Resources/Scripts/Entity")
require("Resources/Scripts/background")
require("Resources/Scripts/player")
require("Resources/Scripts/ai")
require("Resources/Scripts/boss")
require("Resources/Scripts/World")
require("Resources/Scripts/level2")
require("Resources/Scripts/powerup")
require("Resources/Scripts/point_light")
require("Resources/Scripts/save")
require("Resources/Scripts/enemyContainer")

local textureFunc = newTexture
local spriteFunc = newSprite

local level = World:create()
level:addMap(tilemap1)
level:loadGraphics()

local p = Player:create() -- player
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
nextPortal.normalMap = textureFunc("Resources/Sprites/player.png")
nextPortal.texture = textureFunc("Resources/Sprites/player.png")
nextPortal.sprite = spriteFunc(nextPortal.normalMap, nextPortal.texture)
nextPortal:addWorld(level)
nextPortal:setPosition(48 * 5, 48 * 2)

p.spriteHPBar = spriteFunc(500, 50, 0, p.textureHPBar)
spritePos(p.spriteHPBar, 50, 50)
p.spriteHPBarBack = spriteFunc(500, 50, 0, p.textureHPBarBack)
spritePos(p.spriteHPBarBack, 50, 50)

tileSize = 48

local light1 = PointLight:create(0.1,0.1,1,100,tileSize,
"Resources/Sprites/lamp_normal.png",
"Resources/Sprites/lamp_diffuse.png")

local light2 = PointLight:create(0.1,0.1,1, tileSize * 10, tileSize * 2,
"Resources/Sprites/lamp_normal.png",
"Resources/Sprites/lamp_diffuse.png")

local light3 = PointLight:create(1,0.1,0.1,tileSize * 2, tileSize * 20,
"Resources/Sprites/lamp_normal.png",
"Resources/Sprites/lamp_diffuse.png")


local light4 = PointLight:create(1,1,0.1,tileSize * 40, tileSize,
"Resources/Sprites/lamp_normal.png",
"Resources/Sprites/lamp_diffuse.png")

local light5 = PointLight:create(1,1,0.1,tileSize * 2, tileSize * 36,
"Resources/Sprites/lamp_normal.png",
"Resources/Sprites/lamp_diffuse.png")

--powerups
local power_dash = Powerup:create("Resources/Sprites/powerupDash_diffuse.png", "Resources/Sprites/powerupDash_normal.png") -- GIVES DASH
power_dash.entity:setPosition(500, 1500)
power_dash.type = 0
local power_speed = Powerup:create("Resources/Sprites/powerupSpeed_diffuse.png", "Resources/Sprites/powerupSpeed_normal.png") -- GIVES SPEED INCREASE
power_speed.entity:setPosition(700, 1500)
power_speed.type = 1
local power_jump = Powerup:create("Resources/Sprites/powerupDoubleJump_diffuse.png", "Resources/Sprites/powerupDoubleJump_normal.png") -- GIVES DOUBLE JUMP
power_jump.entity:setPosition(800, 1500)
power_jump.type = 2
local power_highjump = Powerup:create("Resources/Sprites/powerupHighJump_diffuse.png", "Resources/Sprites/powerupHighJump_normal.png") -- GIVES HIGH JUMP
power_highjump.entity:setPosition(900, 1500)
power_highjump.type = 3

addEnemy(1055, 1055, 120, 120. level)

local b = Boss:create(1500, 100, 500, 500) -- bossman
b.entity:addWorld(level)


local bg = Background:create()
bg.texture = textureFunc("Resources/Sprites/backgroundTileBig_diffuse.png")
bg.normalMap = textureFunc("Resources/Sprites/backgroundTileBig_normal.png")
bg.sprite = newBackground(720 * 10, 720 * 10, bg.normalMap, bg.texture)
--bg:setPosition(100, 100)]]

require("Resources/Scripts/playerInput")

function update(deltaTime)
	
	checkUpgrades(deltaTime)

	p:update(deltaTime)
	s:setPosition(p.entity.x + mX, p.entity.y + mY)

	if nextPortal:containsCollisionBox(p) then
		savePowerup(p.entity.hasPowerUp)
		newState("Resources/Scripts/LuaStates/victoryState.lua")
	end

	power_dash:contains(p.entity)
	power_speed:contains(p.entity)
	power_jump:contains(p.entity)
	power_highjump:contains(p.entity)

	updateEnemies(p, deltaTime)
	
	b:update(deltaTime, p)
	b:attack(p)

	pX, pY = getCameraPosition()
	bg:setPosition(pX / 3 - (1280 / 2), pY / 3 - (720 / 2), 1)-- position.y - (720 / 2))

	return true
end

