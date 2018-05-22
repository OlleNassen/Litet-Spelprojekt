require("Resources/Scripts/Entity")
require("Resources/Scripts/background")
require("Resources/Scripts/player")
require("Resources/Scripts/ai")
require("Resources/Scripts/World")
require("Resources/Scripts/powerup")
require("Resources/Scripts/Portal")
require("Resources/Scripts/saw")
require("Resources/Scripts/point_light")
require("Resources/Scripts/save")
require("Resources/Scripts/enemyContainer")

local textureFunc = newTexture
local spriteFunc = newSprite

newMusic("Resources/Sound/darktimes.wav")

level = World:create()
level:addMap(tilemap)
level:loadGraphics()

p = Player:create() -- player

p.entity:addWorld(level)

require("Resources/Scripts/playerInput")

s = Entity:create() -- pixie
s.x = 200
s.y = 100
s.maxSpeed.x = 200
s.maxSpeed.y = 200
s.normalMap = textureFunc("Resources/Sprites/player.png")
s.texture = textureFunc("Resources/Sprites/player.png")
s.sprite = spriteFunc(1, 1, s.normalMap, s.texture)
s:addWorld(level)

-- HP bar

p.spriteHPBarBack = spriteFunc(400, 40, 0, p.textureHPBarBack)
spritePos(p.spriteHPBarBack, 10, 20)
p.spriteHPBar = spriteFunc(400, 25, 0, p.textureHPBar)
spritePos(p.spriteHPBar, 10, 27.5)

tileSize = 48

-- Background
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