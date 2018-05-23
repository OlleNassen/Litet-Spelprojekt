tilemap = require("Resources/Scripts/LuaStates/Map/Levels/LevelMenu")
require("Resources/Scripts/common")
require("Resources/Scripts/Entity")
require("Resources/Scripts/World")
require("Resources/Scripts/background")
require("Resources/Scripts/point_light")

local textureFunc = newTexture
local spriteFunc = newSprite
local settexture = setTexture

newMusic("Resources/Sound/darktimes.wav")

saveData(19, 0)

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

local play = Entity:create() 
play.texture = textureFunc("Resources/Sprites/btn_play.png")
texture2 = textureFunc("Resources/Sprites/btn_play_pressed.png")
play.sprite = spriteFunc(400,100, 0, play.texture)
play.width = 400
play.height = 100
play:setPosition(450,200)

local exit = Entity:create() 
exit.texture = textureFunc("Resources/Sprites/btn_quit.png")
texture3 = textureFunc("Resources/Sprites/btn_quit_pressed.png")
exit.sprite = spriteFunc(400,100, 0, exit.texture)
exit.width = 400
exit.height = 100
exit:setPosition(450, 350)

function update(deltaTime)
	s:setPosition(mX, mY)
	updateBackground()

	if play:contains(s.x, s.y) then
		settexture(play.sprite, texture2)
	else
		settexture(play.sprite, play.texture)
	end

	if exit:contains(s.x, s.y) then
		settexture(exit.sprite, texture3)
	else
		settexture(exit.sprite, exit.texture)
	end

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

function mouseLeft()
	if play:contains(s.x, s.y) then
		newState("Resources/Scripts/LuaStates/Map/Level1State.lua")
	end

	if exit:contains(s.x, s.y) then
		deleteState()
	end
end