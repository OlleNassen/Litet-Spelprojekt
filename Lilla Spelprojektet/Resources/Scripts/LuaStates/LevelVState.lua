require("Resources/Scripts/Entity")
require("Resources/Scripts/background")
require("Resources/Scripts/player")
require("Resources/Scripts/ai")
require("Resources/Scripts/World")
require("Resources/Scripts/vincent")
require("Resources/Scripts/powerup")
require("Resources/Scripts/point_light")
require("Resources/Scripts/save")

local textureFunc = newTexture
local spriteFunc = newSprite

local level = World:create()
level:addMap(tilemap1)
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
	saveData(0, 1)
end

p.entity:addWorld(level)
p.entity:setPosition(48 * 2, 16 * 48)


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
nextPortal:setPosition(48 * 5, 48 * 2)

local backPortal = Entity:create()
backPortal.offsetX = 12
backPortal.collision_width = 24
backPortal.collision_height = 96
backPortal.texture = textureFunc("Resources/Sprites/door_diffuse.png")
backPortal.normalMap = textureFunc("Resources/Sprites/door_normal.png")
backPortal.sprite = spriteFunc(nextPortal.normalMap, nextPortal.texture)
backPortal:setSize(48, 96)
backPortal:addWorld(level)
backPortal:setPosition(48, 17 * 48)

p.spriteHPBar = spriteFunc(500, 50, 0, p.textureHPBar)
spritePos(p.spriteHPBar, 50, 50)
p.spriteHPBarBack = spriteFunc(500, 50, 0, p.textureHPBarBack)
spritePos(p.spriteHPBarBack, 50, 50)

tileSize = 48

local light1 = PointLight:create(1.0, 1.0, 1.0, tileSize * 5, tileSize * 17,
"Resources/Sprites/lamp_normal.png",
"Resources/Sprites/lamp_diffuse.png")

local light2 = PointLight:create(1.0, 1.0, 1.0, tileSize * 13, tileSize * 6,
"Resources/Sprites/lamp_normal.png",
"Resources/Sprites/lamp_diffuse.png")

local light3 = PointLight:create(1.0, 1.0, 1.0,tileSize * 21, tileSize * 11,
"Resources/Sprites/lamp_normal.png",
"Resources/Sprites/lamp_diffuse.png")


local light4 = PointLight:create(1.0, 1.0, 1.0, tileSize * 34, tileSize * 6,
"Resources/Sprites/lamp_normal.png",
"Resources/Sprites/lamp_diffuse.png")

local light5 = PointLight:create(1.0, 1.0, 1.0 ,tileSize * 2, tileSize * 2,
"Resources/Sprites/lamp_normal.png",
"Resources/Sprites/lamp_diffuse.png")

--powerups  [None]

local g = Ai:create(tileSize * 16, tileSize * 16, 120, 120) -- goomba
g.entity:addWorld(level)


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
		newState("Resources/Scripts/LuaStates/olleState.lua")
	end

	if backPortal:containsCollisionBox(p) then
		savePowerup(p.entity.hasPowerUp)
		newState("Resources/Scripts/LuaStates/edvardState.lua")
	end

	--power_dash:contains(p.entity)
	--power_speed:contains(p.entity)
	--power_jump:contains(p.entity)
	--power_highjump:contains(p.entity)

	g:update(deltaTime)	
	g:attack(p)

	if p.isAttacking == true then
		if g.entity:contains(p.entity.x + p.entity.width, p.entity.y + (p.entity.height / 2)) == true then
			g.entity:takeDamage(p.attackDamage, p.attackPushBack.x, p.attackPushBack.y, true)
		end
	end
	
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

