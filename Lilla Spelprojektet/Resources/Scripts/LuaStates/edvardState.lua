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
nextPortal.normalMap = textureFunc("Resources/Sprites/player.png")
nextPortal.texture = textureFunc("Resources/Sprites/player.png")
nextPortal.sprite = spriteFunc(nextPortal.normalMap, nextPortal.texture)
nextPortal:addWorld(level)
nextPortal:setPosition(48 * 47, 48 * 3)

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

local bg = Background:create()
bg.texture = textureFunc("Resources/Sprites/backgroundTileBig_diffuse.png")
bg.normalMap = textureFunc("Resources/Sprites/backgroundTileBig_normal.png")
bg.sprite = newBackground(720 * 10, 720 * 10, bg.normalMap, bg.texture)


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
	bg:setPosition(pX / 3 - (1280 / 2), pY / 3 - (720 / 2))-- position.y - (720 / 2))

	return true
end

