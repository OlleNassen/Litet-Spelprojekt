require("Resources/Scripts/Entity")

local p = Entity:create() -- player
p.texture = newTexture("Resources/Sprites/Player/playerDiffuse.png")


local cam = newSprite(1, 1, 0, p.texture)

local s = Entity:create()
s.x = 0
s.y = 0
s.speed = 200
s.texture = newTexture("Resources/Sprites/mouseDiffuse.png")
s.normalMap = newTexture("Resources/Sprites/mouseNormal.png")
s.sprite = newSprite(s.normalMap, s.texture)
s:setPosition(s.x, s.y)


local play = Entity:create() 
play.normalMap = newTexture("Resources/Sprites/mainMenu_normal.png")
play.texture = newTexture("Resources/Sprites/play.png")
play.sprite = newSprite(800,100, play.normalMap, play.texture)
play.width = 800
play.height = 100
play:setPosition(-400,-300)

local editor = Entity:create() 
editor.normalMap = newTexture("Resources/Sprites/mainMenu_normal.png")
editor.texture = newTexture("Resources/Sprites/editor.png")
editor.sprite = newSprite(800,100, editor.normalMap, editor.texture)
editor:setPosition(-400,-150)

local exit = Entity:create() 
exit.normalMap = newTexture("Resources/Sprites/mainMenu_normal.png")
exit.texture = newTexture("Resources/Sprites/quit.png")
exit.sprite = newSprite(800,100, exit.normalMap, exit.texture)
exit.width = 800
exit.height = 100
exit:setPosition(-400,-0)

local b = Entity:create() 
b.normalMap = newTexture("Resources/Sprites/mainMenu_normal.png")
b.texture = newTexture("Resources/Sprites/menu.png")
b.sprite = newSprite(1280,720, b.normalMap, b.texture)
b:setPosition(-1280/2, -720/2)

function moveUp(direction, deltaTime)
	--p:move(direction * p.speed * deltaTime, 0)
end

function moveRight(direction, deltaTime)
	--p:move(direction * p.speed * deltaTime, 0)
end

function quit(direction, deltaTime)
	pop()
end

function select(direction, deltaTime)
	push("Resources/Scripts/LuaStates/gameState.lua")
end

function selectEditor(direction, deltaTime)
	push("Resources/Scripts/LuaStates/editorState.lua")
end

mX = 0.0
mY = 0.0

function mouse(x, y)
	mX = mX + x
	mY = mY + y
	s:setPosition(
	math.max(math.min(p.x + mX - 1280, 1280/2-48), -1280/2), 
	math.max(math.min(p.y + mY - 720, 720/2-48), -720/2))
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