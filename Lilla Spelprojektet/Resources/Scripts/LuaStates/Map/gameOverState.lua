tilemap = require("Resources/Scripts/LuaStates/Map/Levels/LevelMenu")
require("Resources/Scripts/common")
require("Resources/Scripts/Entity")
require("Resources/Scripts/World")
require("Resources/Scripts/background")
require("Resources/Scripts/point_light")

local textureFunc = newTexture
local spriteFunc = newSprite
local settexture = setTexture

saveData(19,420)

spritePos(p.spriteHPBarBack, 10000, 20)
spritePos(p.spriteHPBar, 10000, 27.5)
if p.entity.hasPowerUp[5] then
	spritePos(p.spriteLaserBarBack, 10000, 60)
	spritePos(p.spriteLaserBar, 10000, 64)
end
p:reset()

--Min 28x15 tiles

tileSize = 48

local color = 1
local light1 = PointLight:create(color, color, color, 4 * tileSize, tileSize * 5)
local light2 = PointLight:create(color, color, color, 23 * tileSize, tileSize * 5)

local bgs = {}

bgs[1] = Background:create()
bgs[1].texture = textureFunc("Resources/Sprites/Background/Pillar_diffuse_48.png")
bgs[1].sprite = newBackground(50, 2400, 0, bgs[1].texture)

bgs[2] = Background:create()
bgs[2].sprite = newBackground(50, 2400, 0, bgs[1].texture)

bgs[3] = Background:create()
bgs[3].sprite = newBackground(50, 2400, 0, bgs[1].texture)

local totalFurthestSprites = 3

bgs[4] = Background:create()
bgs[4].texture = textureFunc("Resources/Sprites/Background/Pillar_diffuse.png")
bgs[4].sprite = newBackground(100, 3200, 0, bgs[4].texture)

bgs[5] = Background:create()
bgs[5].sprite = newBackground(100, 3200, 0, bgs[4].texture)

bgs[6] = Background:create()
bgs[6].sprite = newBackground(100, 3200, 0, bgs[4].texture)

local gameOver = Entity:create() 
gameOver.texture = textureFunc("Resources/Sprites/btn_hs.png")
texture3 = textureFunc("Resources/Sprites/btn_hs_pressed.png")
gameOver.sprite = spriteFunc(400,100, 0, gameOver.texture)
gameOver.width = 400
gameOver.height = 100
gameOver:setPosition(450, 300)

timer = 0.0
function update(deltaTime)
	s:setPosition(mX, mY)
	timer = timer + deltaTime
	
	if timer > 2.0 then
		newState("Resources/Scripts/LuaStates/Map/MenuState.lua")
	end
	updateBackground()
end

function updateBackground()
	pX, pY = getCameraPosition()
	for k, v in pairs(bgs) do
		if k <= totalFurthestSprites then
			v:setPosition(pX * 0.01  + (400 * k - 1), pY * -0.05 - 100, k)
		else
			index = k - totalFurthestSprites
			v:setPosition(pX * 0.1 + (index * 600), pY * -0.2, k)
		end
	end
end