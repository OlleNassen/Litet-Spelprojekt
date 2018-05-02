require("Resources/Scripts/Entity")

local textureFunc = newTexture
local spriteFunc = newSprite

local p = Entity:create() -- player
p.texture = textureFunc("Resources/Sprites/Player/playerDiffuse.png")

local cam = newSprite(1, 1, 0, p.texture)

local s = Entity:create()
s.speed = 200
s.texture = textureFunc("Resources/Sprites/mouseDiffuse.png")
s.sprite = spriteFunc(0, s.texture)


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
	pop()
end

function selectGame(direction, deltaTime)
	push("Resources/Scripts/LuaStates/gameState.lua")
end

function selectEditor(direction, deltaTime)
	push("Resources/Scripts/LuaStates/editorState.lua")
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
		push("Resources/Scripts/LuaStates/gameState.lua")
	end

	if exit:contains(s.x, s.y) then
		pop()
	end
end

function update(deltaTime)

end