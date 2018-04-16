require("Resources/Scripts/Entity")

local s = Entity:create() 
s.texture = newTexture("Resources/Sprites/menu.png")

local cam = newSprite(0, 0, 0, s.texture)

s.sprite = newSprite(1280,720, 0, s.texture)
s:setPosition(-1280/2, -720/2)


local play = Entity:create() 
play.texture = newTexture("Resources/Sprites/play.png")
play.sprite = newSprite(800,100, 0, play.texture)
play:setPosition(-400,-300)

local editor = Entity:create() 
editor.texture = newTexture("Resources/Sprites/editor.png")
editor.sprite = newSprite(800,100, 0, editor.texture)
editor:setPosition(-400,100)

local exit = Entity:create() 
exit.texture = newTexture("Resources/Sprites/quit.png")
exit.sprite = newSprite(800,100, 0, exit.texture)
exit:setPosition(-400,210)



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

function update(deltaTime)
end