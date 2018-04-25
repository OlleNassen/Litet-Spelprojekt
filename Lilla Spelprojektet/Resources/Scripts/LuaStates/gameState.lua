require("Resources/Scripts/Entity")
require("Resources/Scripts/background")
require("Resources/Scripts/player")
require("Resources/Scripts/ai")
require("Resources/Scripts/World")
require("Resources/Scripts/level2")
require("Resources/Scripts/powerup")
require("Resources/Scripts/point_light")


function quit()
	pop()
end

local level = World:create()
level:addMap(tilemap1)
level:loadGraphics()



-- PowerUps
-- Dash
dashing = false
towardsX = 0
towardsY = 0
hasFoundPosition = false

local p = Player:create() -- player
p.entity:addWorld(level)


local s = Entity:create() -- pixie
s.x = 200
s.y = 100
s.maxSpeed.x = 200
s.maxSpeed.y = 200
s.texture = newTexture("Resources/Sprites/player.png")
s.sprite = newSprite(s.texture)
s:addWorld(level)

local light1 = PointLight:create(0.1,0.1,1,100,100,
0,
"Resources/Sprites/torch.png")

local light2 = PointLight:create(0.1,0.1,1,500,100,
0,
"Resources/Sprites/torch.png")

local light3 = PointLight:create(1,0.1,0.1,100,1000,
0,
"Resources/Sprites/torch.png")

local light4 = PointLight:create(1,0.1,1,500,1000,
0,
"Resources/Sprites/torch.png")

local light5 = PointLight:create(1,1,0.1,2000,100,
0,
"Resources/Sprites/torch.png")

local light6 = PointLight:create(1,1,0.1,100,1400,
0,
"Resources/Sprites/torch.png")
--[[
local light7 = PointLight:create(1,1,0.1,100,1400,
0,
"Resources/Sprites/torch.png")
]]
local g = Ai:create() -- goomba
g.entity:addWorld(level)

local power_speed = Powerup:create() -- Powerup speed 1
power_speed.entity:setPosition(500, 1500)
power_speed.type = 0

local b = Entity:create() -- goomba
b.x = 300
b.y = 200
b.texture = newTexture("Resources/Sprites/bossman.png")
b.sprite = newSprite(b.texture)
b:addWorld(level)
b:move(0,0)

local bg = Background:create()
bg.texture = newTexture("Resources/Sprites/backgroundTileBig_diffuse.png")
bg.normalMap = newTexture("Resources/Sprites/backgroundTileBig_normal.png")
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
	dashing = true
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
	if p.entity.hasPowerUp[1] == true then
		
		if dashing == true then
			p.entity.hasGravity = false;
			if hasFoundPosition == false then
				towardsX = s.x
				towardsY = s.y
				hasFoundPosition = true
			end

			local tempX = towardsX - p.entity.x 
			local tempY = towardsY - p.entity.y 
			local lenght = math.sqrt((tempX * tempX) + (tempY * tempY))
			tempX = (tempX / lenght) * 20
			tempY = (tempY / lenght) * 20
			
			p.entity:move(tempX, tempY)

			if lenght < 30 or p.entity.collision_top == true then
				dashing = false
				p.entity.hasGravity = true
				hasFoundPosition = false
			end
		end
	end
end

function update(deltaTime)
	
	checkUpgrades(deltaTime)

	p:update(deltaTime)
	s:setPosition(p.entity.x + mX, p.entity.y + mY)

	g:update(deltaTime)
	power_speed:contains(p.entity)
	
	if p.entity:contains(b.x, b.y) then
		push("Resources/Scripts/LuaStates/gameOverState.lua")
	end

	position = p:getPosition()
	bg:setPosition(position.x / 3 - (1280 / 2), position.y / 3 - (720 / 2))-- position.y - (720 / 2))

	return true
end

