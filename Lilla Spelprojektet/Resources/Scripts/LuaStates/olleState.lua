require("Resources/Scripts/Entity")
require("Resources/Scripts/background")
require("Resources/Scripts/player")
require("Resources/Scripts/ai")
require("Resources/Scripts/World")
require("Resources/Scripts/olleTilemap")
require("Resources/Scripts/powerup")
require("Resources/Scripts/point_light")

local textureFunc = newTexture
local spriteFunc = newSprite

function quit()
	pop()
end

local level = World:create()
level:addMap(olleTilemap)
level:loadGraphics()

-- PowerUps
-- Dash
towardsX = 0
towardsY = 0
hasFoundPosition = false

local p = Player:create() -- player
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
nextPortal.normalMap = textureFunc("Resources/Sprites/player.png")
nextPortal.texture = textureFunc("Resources/Sprites/player.png")
nextPortal.sprite = spriteFunc(nextPortal.normalMap, nextPortal.texture)
nextPortal:addWorld(level)
nextPortal:setPosition(48 * 24, 48 * 2)

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
--[[
local power_dash = Powerup:create("Resources/Sprites/powerupDash_diffuse.png", "Resources/Sprites/powerupDash_normal.png") -- GIVES DASH
power_dash.entity:setPosition(500, 1500)
power_dash.type = 0
local power_speed = Powerup:create("Resources/Sprites/powerupSpeed_diffuse.png", "Resources/Sprites/powerupSpeed_normal.png") -- GIVES SPEED INCREASE
power_speed.entity:setPosition(700, 1500)
power_speed.type = 1
]]
local power_jump = Powerup:create("Resources/Sprites/powerupDoubleJump_diffuse.png", "Resources/Sprites/powerupDoubleJump_normal.png") -- GIVES DOUBLE JUMP
power_jump.entity:setPosition(430, 580)
power_jump.type = 2
--[[
local power_highjump = Powerup:create("Resources/Sprites/powerupHighJump_diffuse.png", "Resources/Sprites/powerupHighJump_normal.png") -- GIVES HIGH JUMP
power_highjump.entity:setPosition(900, 1500)
power_highjump.type = 3
]]
local goomba1 = Ai:create(48,36 * 48, 120, 120) -- goomba
goomba1.entity:addWorld(level)
local goomba2 = Ai:create(48 * 2,36 * 48, 120, 120) -- goomba2
goomba2.entity:addWorld(level)

local goomba3 = Ai:create(1000,1000, 120, 120) -- goomba
goomba3.entity:addWorld(level)
local goomba4 = Ai:create(1000,1000, 120, 120) -- goomba
goomba4.entity:addWorld(level)
local goomba5 = Ai:create(1000,1000, 120, 120) -- goomba
goomba5.entity:addWorld(level)
local goomba6 = Ai:create(1000,1000, 120, 120) -- goomba
goomba6.entity:addWorld(level)
local goomba7 = Ai:create(1000,1000, 120, 120) -- goomba
goomba7.entity:addWorld(level)
local goomba8 = Ai:create(1000,1000, 120, 120) -- goomba
goomba8.entity:addWorld(level)


local b = Ai:create(1500, 100, 500, 500) -- bossman
b.entity:addWorld(level)


local bg = Background:create()
bg.texture = textureFunc("Resources/Sprites/backgroundTileBig_diffuse.png")
bg.normalMap = textureFunc("Resources/Sprites/backgroundTileBig_normal.png")
bg.sprite = newBackground(720 * 10, 720 * 10, bg.normalMap, bg.texture)
--bg:setPosition(100, 100)]]


function moveUp(direction, deltaTime)
	return p:moveUp(direction, deltaTime)
end

function moveRight(direction, deltaTime)
	return p:moveRight(direction, deltaTime)
end

function jump()
	return p:jump()
end

function dash()
	
	if p.canDash == true and p.entity.hasPowerUp[1] == true then --Activate dash
		p.entity.collision_bottom = false
		p.dashing = true
		p.canDash = false
	end
	
end

function fly()
	return p:fly()
end

mX = 0.0
mY = 0.0

function mouse(x, y)
	mX = mX + x
	mY = mY + y
end

function checkUpgrades(deltaTime)
	if p.entity.hasPowerUp[1] == true then -- DASH UPGRADE
	
		if p.entity.collision_bottom == true then --Cant dash until on ground
			p.canDash = true
		end

		if p.dashing == true then --Dashing
			p.entity.hasGravity = false
			p.canDash = false
			if hasFoundPosition == false then
				towardsX = s.x
				towardsY = s.y
				hasFoundPosition = true
			end

			local tempX = towardsX - p.entity.x 
			local tempY = towardsY - p.entity.y 
			local length = math.sqrt((tempX * tempX) + (tempY * tempY))
			tempX = (tempX / length)
			tempY = (tempY / length)
	
			p.entity.velocity.x = tempX * 2000
			p.entity.velocity.y = tempY * 2000

			print(p.entity.velocity.x)
			print(p.entity.velocity.y)

			--Dashing ends
			if length < 30 or p.entity.collision_top == true or  p.entity.collision_left == true or p.entity.collision_right == true or p.entity.collision_bottom == true then
				p.dashing = false
				p.entity.hasGravity = true
				hasFoundPosition = false
				p.entity.velocity.x = p.entity.velocity.x / 5
				p.entity.velocity.y = p.entity.velocity.y / 5
			end
		end
	end
	if p.entity.hasPowerUp[2] == true then -- SPEED UPGRADE
		p.entity.maxSpeed.x = 800
	end
	if p.entity.hasPowerUp[3] == true then -- DOUBLE JUMP UPGRADE
		p.maxNrOfJumps = 2
	end
	if p.entity.hasPowerUp[4] == true then -- HIGH JUMP UPGRADE
		p.jumpPower = -1800
	end
end

function update(deltaTime)
	
	checkUpgrades(deltaTime)

	p:update(deltaTime)
	s:setPosition(p.entity.x + mX, p.entity.y + mY)

	if nextPortal:containsCollisionBox(p) then
		push("Resources/Scripts/LuaStates/LevelVState.lua")
	end

	--[[
	power_dash:contains(p.entity)
	power_speed:contains(p.entity)
	power_highjump:contains(p.entity)
	]]
	power_jump:contains(p.entity)
	
	goomba1:update(deltaTime)	
	goomba2:update(deltaTime)

	goomba3:update(deltaTime)	
	goomba4:update(deltaTime)	
	goomba5:update(deltaTime)	
	goomba6:update(deltaTime)
	goomba7:update(deltaTime)	
	goomba8:update(deltaTime)

	goomba1:attack(p)
	goomba2:attack(p)

	goomba3:attack(p)	
	goomba4:attack(p)	
	goomba5:attack(p)	
	goomba6:attack(p)
	goomba7:attack(p)	
	goomba8:attack(p)
	
	
	b:attack(p)
	
	pX, pY = getCameraPosition()
	bg:setPosition(pX / 3 - (1280 / 2), pY / 3 - (720 / 2))-- position.y - (720 / 2))

	return true
end

