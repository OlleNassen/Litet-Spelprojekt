require("Resources/Scripts/Entity")
require("Resources/Scripts/background")
require("Resources/Scripts/player")
require("Resources/Scripts/ai")
require("Resources/Scripts/World")
require("Resources/Scripts/powerup")
require("Resources/Scripts/saw")
require("Resources/Scripts/point_light")
require("Resources/Scripts/save")
require("Resources/Scripts/Portal")
require("Resources/Scripts/LuaStates/Map/Levels/Level2")

m = newMusic("Resources/Sound/canary.wav")

--Min 28x15 tiles

local textureFunc = newTexture
local spriteFunc = newSprite

function quit()
	deleteState()
end

local level = World:create()
level:addMap(tilemap)
level:loadGraphics()



-- PowerUps
-- Dash
towardsX = 0
towardsY = 0
hasFoundPosition = false

local p = Player:create() -- player

if loadData(0) == 0 then
	p.entity.x = 98
	p.entity.y = 48 * 16
	saveData(0, 0)

elseif loadData(0) == 1 then 
	p.entity.x = 48 * 45
	p.entity.y = 48 * 3
	saveData(0, 0)

end

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

local level3Portal = Portal:create(48 * 47, 48 * 4)

p.spriteHPBar = spriteFunc(500, 50, 0, p.textureHPBar)
spritePos(p.spriteHPBar, 50, 50)
p.spriteHPBarBack = spriteFunc(500, 50, 0, p.textureHPBarBack)
spritePos(p.spriteHPBarBack, 50, 50)

tileSize = 48

local color = 1

local light1 = PointLight:create(color, color, color, 10 * tileSize, tileSize * 9,
"Resources/Sprites/lamp_normal.png",
"Resources/Sprites/lamp_diffuse.png")

local light2 = PointLight:create(color, color, color, 24 * tileSize, tileSize,
"Resources/Sprites/lamp_normal.png",
"Resources/Sprites/lamp_diffuse.png")

local light3 = PointLight:create(color, color, color, tileSize, tileSize * 14,
"Resources/Sprites/lamp_normal.png",
"Resources/Sprites/lamp_diffuse.png")


local light4 = PointLight:create(color, color, color,tileSize * 39, tileSize,
"Resources/Sprites/lamp_normal.png",
"Resources/Sprites/lamp_diffuse.png")

local light5 = PointLight:create(color, color, color, tileSize * 2, tileSize * 36,
"Resources/Sprites/lamp_normal.png",
"Resources/Sprites/lamp_diffuse.png")

local enemy1 = Ai:create(42 * 48, 48 * 9, 120, 120) -- goomba
enemy1.entity:addWorld(level)

local enemy2 = Ai:create(38 * 48, 48 * 9, 120, 120) -- goomba
enemy2.entity:addWorld(level)

local enemy3 = Ai:create(34 * 48, 48 * 9, 120, 120) -- goomba
enemy3.entity:addWorld(level)

local enemy4 = Ai:create(30 * 48, 48 * 9, 120, 120) -- goomba
enemy4.entity:addWorld(level)

local enemy5 = Ai:create(26 * 48, 48 * 9, 120, 120) -- goomba
enemy5.entity:addWorld(level)

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

function moveUp(direction, deltaTime)
	return p:moveUp(direction, deltaTime)
end

function moveRight(direction, deltaTime)
	return p:moveRight(direction, deltaTime)
end

function dash()
	if p.canDash == true and p.entity.hasPowerUp[1] == true then --Activate dash
		p.entity.collision_bottom = false
		p.dashing = true
		p.canDash = false
	end
end

function jump()
	return p:jump()
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


function update(deltaTime)
	checkUpgrades(deltaTime)

	p:update(deltaTime)
	s:setPosition(p.entity.x + mX, p.entity.y + mY)

	if level3Portal.entity:containsCollisionBox(p) then
		savePowerup(p.entity.hasPowerUp)
		newState("Resources/Scripts/LuaStates/Map/Level3State.lua")
	end

	updateEntitys(deltaTime)

	updateBackground()
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

			--print(p.entity.velocity.x)
			--print(p.entity.velocity.y)

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
		p.jumpPower = -1500
	end
end

function updateEntitys(deltaTime)
	enemy1:update(deltaTime)	
	enemy2:update(deltaTime)
	enemy3:update(deltaTime)
	enemy4:update(deltaTime)
	enemy5:update(deltaTime)
	enemy1:attack(p)
	enemy2:attack(p)
	enemy3:attack(p)
	enemy4:attack(p)
	enemy5:attack(p)
end

function updateBackground()
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