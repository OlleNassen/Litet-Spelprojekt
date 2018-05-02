require("Resources/Scripts/Entity")

local textureFunc = newTexture
local spriteFunc = newSprite

local p = Entity:create() -- player
p.texture = textureFunc("Resources/Sprites/Player/playerDiffuse.png")

local cam = newSprite(1, 1, 0, p.texture)

local s = Entity:create()
s.x = 0
s.y = 0
s.speed = 200
s.texture = textureFunc("Resources/Sprites/mouseDiffuse.png")
s.normalMap = textureFunc("Resources/Sprites/mouseNormal.png")
s.sprite = spriteFunc(s.normalMap, s.texture)
s:setPosition(s.x, s.y)


local play = Entity:create() 
play.normalMap = textureFunc("Resources/Sprites/mainMenu_normal.png")
play.texture = textureFunc("Resources/Sprites/play.png")
play.sprite = spriteFunc(800,100, play.normalMap, play.texture)
play.width = 800
play.height = 100
play:setPosition(-400,-300)

local editor = Entity:create() 
editor.normalMap = textureFunc("Resources/Sprites/mainMenu_normal.png")
editor.texture = textureFunc("Resources/Sprites/editor.png")
editor.sprite = spriteFunc(800,100, editor.normalMap, editor.texture)
editor:setPosition(-400,-150)

local exit = Entity:create() 
exit.normalMap = textureFunc("Resources/Sprites/mainMenu_normal.png")
exit.texture = textureFunc("Resources/Sprites/quit.png")
exit.sprite = spriteFunc(800,100, exit.normalMap, exit.texture)
exit.width = 800
exit.height = 100
exit:setPosition(-400,-0)

local b = Entity:create() 
b.normalMap = textureFunc("Resources/Sprites/mainMenu_normal.png")
b.texture = textureFunc("Resources/Sprites/menu.png")
b.sprite = spriteFunc(1280,720, b.normalMap, b.texture)
b:setPosition(-1280/2, -720/2)

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
	max(min(p.x + mX - 1280, 1280/2-48), -1280/2), 
	max(min(p.y + mY - 720, 720/2-48), -720/2))
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