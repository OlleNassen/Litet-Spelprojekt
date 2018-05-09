require("Resources/Scripts/Entity")
require("Resources/Scripts/background")
require("Resources/Scripts/player")
require("Resources/Scripts/ai")
require("Resources/Scripts/World")
require("Resources/Scripts/powerup")
require("Resources/Scripts/point_light")

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

saveData(3000, 9)
saveData(2000, 7)
saveData(1000, 5)
loadData(3000)

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
p.entity.x = 98
p.entity.y = 48 * 16
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
bgs[4].sprite = newBackground(100, 800, 0, bgs[4].texture)

bgs[5] = Background:create()
bgs[5].sprite = newBackground(100, 800, 0, bgs[4].texture)

bgs[6] = Background:create()
bgs[6].sprite = newBackground(100, 800, 0, bgs[4].texture)

function moveUp(direction, deltaTime)
	return p:moveUp(direction, deltaTime)
end

function moveRight(direction, deltaTime)
	return p:moveRight(direction, deltaTime)
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
	
	p:update(deltaTime)
	s:setPosition(p.entity.x + mX, p.entity.y + mY)

	if nextPortal:containsCollisionBox(p) then
		newState("Resources/Scripts/LuaStates/olleState.lua")
	end

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
	
	pX, pY = getCameraPosition()
	--bg:setPosition(pX / 3 - (1280 / 2), pY / 3 - (720 / 2))-- position.y - (720 / 2))
	
	for k, v in pairs(bgs) do
		if k <= totalFurthestSprites then
			v:setPosition(pX / 6 + (400 * k), pY / 4, k)
		else
			v:setPosition(1000-pX*0.1 , 1000-pY*0.1, k)
			--v:setPosition(pX / -3,pY / -4 + 100, k)
			print(pX, pY)
		end
	end
end

