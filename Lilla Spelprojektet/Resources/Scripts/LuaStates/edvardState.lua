require("Resources/Scripts/Entity")
require("Resources/Scripts/background")
require("Resources/Scripts/player")
require("Resources/Scripts/ai")
require("Resources/Scripts/World")
require("Resources/Scripts/powerup")
require("Resources/Scripts/saw")
require("Resources/Scripts/point_light")
require("Resources/Scripts/save")
require("Resources/Scripts/enemyContainer")

m = newMusic("Resources/Sound/canary.wav")

tilemap =
{
	texturesDiffuse = 
	{
		"Resources/Sprites/brickwall.png",
		"Resources/Sprites/brick_diffuse.png", 
		"Resources/Sprites/pyramid_diffuse.png",
		"Resources/Sprites/ironPillar_diffuse.png",
		"Resources/Sprites/lockerBottom_diffuse.png",
		"Resources/Sprites/lockerTop_diffuse.png",

	},

	texturesNormal = 
	{
		"Resources/Sprites/brickwall_normal.png", 
		"Resources/Sprites/brick_normal.png", 
		"Resources/Sprites/pyramid_normal.png",
		"Resources/Sprites/ironPillar_normal.png",
		"Resources/Sprites/lockerBottom_normal.png",
		"Resources/Sprites/lockerTop_normal.png",
	},

	ignore = 
	{
		true, 
		false, 
		false, 
		true, 
		true, 
		true,
	},
	
	tiles = 
	{
		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
		1,0,0,0,0,0,3,0,0,0,3,0,0,0,0,0,0,3,0,0,0,3,0,0,0,0,0,3,0,0,0,0,0,3,0,0,3,3,0,0,3,3,0,0,0,0,0,0,0,1,
		1,0,0,0,0,0,3,0,0,0,3,0,0,0,0,0,0,3,0,0,0,3,0,0,0,0,0,3,0,0,0,0,0,3,0,0,3,3,0,0,3,3,0,0,0,0,0,0,0,1,
		1,0,0,0,0,0,3,0,0,0,3,0,0,0,0,0,0,3,0,0,0,3,0,0,0,0,0,3,0,0,0,0,0,3,0,0,3,3,0,0,3,3,0,0,0,0,0,0,0,1,
		1,0,0,0,0,0,3,0,0,0,3,0,0,0,0,0,0,3,0,0,0,3,0,0,0,0,0,3,0,0,0,0,0,3,0,0,3,3,0,0,3,3,0,0,0,0,0,0,0,1,
		1,0,0,0,0,0,3,0,0,0,3,0,0,0,0,0,0,3,0,0,0,3,0,0,0,0,0,3,0,0,0,0,0,3,0,0,3,3,0,0,3,3,0,0,0,0,0,0,0,1,
		1,0,0,0,0,0,3,0,0,0,3,0,0,0,0,0,0,3,0,0,0,3,0,0,0,0,0,2,0,0,0,0,0,2,0,0,2,2,0,0,2,2,0,0,2,2,2,2,2,1,
		1,0,0,0,0,0,3,0,0,0,3,0,0,0,0,0,0,3,0,0,0,3,0,0,0,0,0,2,0,0,0,0,0,3,0,0,3,3,0,0,3,3,0,0,3,2,1,1,1,1,
		1,0,0,0,0,0,2,2,2,2,2,0,0,0,0,0,0,3,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,3,0,0,3,3,0,0,3,3,0,0,3,0,2,1,1,1,
		1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,3,0,0,3,3,0,0,3,3,0,0,3,0,0,2,1,1,		
		1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,3,3,0,0,3,3,0,0,3,0,0,0,2,1,
		1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,2,2,0,0,2,2,0,0,2,0,0,0,0,1,
		1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,0,0,2,2,0,0,2,2,0,0,0,0,0,1,
		1,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
		1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
		1,0,0,0,0,0,0,0,0,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
		1,0,0,0,0,0,0,0,2,1,1,1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
		1,5,0,0,0,0,0,2,1,1,1,1,1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,1,
		1,4,0,0,0,0,2,1,1,1,1,1,1,1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,4,1,
		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	},

	width = 50,
	height = 20
}

local textureFunc = newTexture
local spriteFunc = newSprite

local level = World:create()
level:addMap(tilemap)
level:loadGraphics()

-- PowerUps
-- Dash
towardsX = 0
towardsY = 0
hasFoundPosition = false

p = Player:create() -- player

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

local nextPortal = Entity:create()
nextPortal.offsetX = 12
nextPortal.collision_width = 24
nextPortal.collision_height = 96
nextPortal.texture = textureFunc("Resources/Sprites/door_diffuse.png")
nextPortal.normalMap = textureFunc("Resources/Sprites/door_normal.png")
nextPortal.sprite = spriteFunc(nextPortal.normalMap, nextPortal.texture)
nextPortal:setSize(48, 96)
nextPortal:addWorld(level)
nextPortal:setPosition(48 * 47, 48 * 4)

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

--Player Visible collision box
	--[[saw.entity.textureHB = newTexture("Resources/Sprites/hitbox.png")
	saw.entity.normalHB = newTexture("Resources/Sprites/hitbox_normal.png")
	saw.entity.spriteHB = newSprite(saw.entity.collision_width, saw.entity.collision_height, saw.entity.normalHB, saw.entity.textureHB)
	spritePos(saw.entity.spriteHB, saw.entity.x + saw.entity.offsetX, saw.entity.y + saw.entity.offsetY)]]

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

require("Resources/Scripts/playerInput")

function update(deltaTime)
	checkUpgrades(deltaTime)

	p:update(deltaTime)
	s:setPosition(p.entity.x + mX, p.entity.y + mY)

	if nextPortal:containsCollisionBox(p) then
		savePowerup(p.entity.hasPowerUp)
		newState("Resources/Scripts/LuaStates/LevelVState.lua")
	end

	updateEnemies(p, deltaTime)

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
		p.jumpPower = -1800
	end
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