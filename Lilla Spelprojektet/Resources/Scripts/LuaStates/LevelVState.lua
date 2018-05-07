require("Resources/Scripts/Entity")
require("Resources/Scripts/background")
require("Resources/Scripts/player")
require("Resources/Scripts/ai")
require("Resources/Scripts/World")
require("Resources/Scripts/vincent")
require("Resources/Scripts/powerup")
require("Resources/Scripts/point_light")

local textureFunc = newTexture
local spriteFunc = newSprite

function quit()
	pop()
end

local level = World:create()
level:addMap(tilemap1)
level:loadGraphics()



-- PowerUps
-- Dash
towardsX = 0
towardsY = 0
hasFoundPosition = false

local p = Player:create() -- player
p.entity:addWorld(level)
p.entity:setPosition(48 * 1, 16 * 48)


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

local light1 = PointLight:create(0.1,0.1,0, tileSize * 5, tileSize * 17,
"Resources/Sprites/lamp_normal.png",
"Resources/Sprites/lamp_diffuse.png")

local light2 = PointLight:create(0.1,0.1,0, tileSize * 13, tileSize * 6,
"Resources/Sprites/lamp_normal.png",
"Resources/Sprites/lamp_diffuse.png")

local light3 = PointLight:create(0.1,0.1,0,tileSize * 21, tileSize * 11,
"Resources/Sprites/lamp_normal.png",
"Resources/Sprites/lamp_diffuse.png")


local light4 = PointLight:create(0.1,0.1,0,tileSize * 34, tileSize * 6,
"Resources/Sprites/lamp_normal.png",
"Resources/Sprites/lamp_diffuse.png")

local light5 = PointLight:create(0.1,0.1,0,tileSize * 2, tileSize * 2,
"Resources/Sprites/lamp_normal.png",
"Resources/Sprites/lamp_diffuse.png")

--powerups  [None]

local g = Ai:create(tileSize * 16, tileSize * 16, 120, 120) -- goomba
g.entity:addWorld(level)


local bg = Background:create()
bg.texture = textureFunc("Resources/Sprites/backgroundTileBig_diffuse.png")
bg.normalMap = textureFunc("Resources/Sprites/backgroundTileBig_normal.png")
bg.sprite = newBackground(720 * 10, 720 * 10, bg.normalMap, bg.texture)


function moveUp(direction, deltaTime)
	return p:moveUp(direction, deltaTime)
end

function mouseLeft()
	return p:attack()
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
		push("Resources/Scripts/LuaStates/victoryState.lua")
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
	bg:setPosition(pX / 3 - (1280 / 2), pY / 3 - (720 / 2))-- position.y - (720 / 2))

	return true
end

