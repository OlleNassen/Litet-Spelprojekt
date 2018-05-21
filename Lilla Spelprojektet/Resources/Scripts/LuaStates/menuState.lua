require("Resources/Scripts/Entity")
require("Resources/Scripts/save")

local textureFunc = newTexture
local spriteFunc = newSprite

local p = Entity:create() -- player
p.texture = textureFunc("Resources/Sprites/Player/playerDiffuse.png")

local cam = newSprite(1, 1, 0, p.texture)

s = Entity:create() -- pixie
s.x = 200
s.y = 100
s.maxSpeed.x = 200
s.maxSpeed.y = 200
s.normalMap = textureFunc("Resources/Sprites/player.png")
s.texture = textureFunc("Resources/Sprites/player.png")
s.sprite = spriteFunc(1, 1, s.normalMap, s.texture)
s:addWorld(level)


local play = Entity:create() 
play.texture = textureFunc("Resources/Sprites/play.png")
play.sprite = spriteFunc(800,100, 0, play.texture)
play.width = 800
play.height = 100
play:setPosition(250,100)

local editor = Entity:create() 
editor.texture = textureFunc("Resources/Sprites/editor.png")
editor.sprite = spriteFunc(800,100, 0, editor.texture)
editor:setPosition(250,300)

local exit = Entity:create() 
exit.texture = textureFunc("Resources/Sprites/quit.png")
exit.sprite = spriteFunc(800,100, 0, exit.texture)
exit.width = 800
exit.height = 100
exit:setPosition(250, 500)

local b = Entity:create() 
b.texture = textureFunc("Resources/Sprites/menu.png")
b.sprite = spriteFunc(1280,720, 0, b.texture)

function quit(direction, deltaTime)
	deleteState()
end

function selectGame(direction, deltaTime)
	newState("Resources/Scripts/LuaStates/gameState.lua")
end

function selectEditor(direction, deltaTime)
	newState("Resources/Scripts/LuaStates/editorState.lua")
end

local mX = 0.0
local mY = 0.0

local max = math.max
local min = math.min

function mouse(x, y)
	mX = mX + x
	mY = mY + y
	s:setPosition(
	max(min(p.x + mX, 1280-48), 0), 
	max(min(p.y + mY, 720-48), 0))
end

function mouseLeft()
	if play:contains(s.x, s.y) then
		newState("Resources/Scripts/LuaStates/gameState.lua")
	end

	if exit:contains(s.x, s.y) then
		deleteState()
	end
end

function update(deltaTime)

end