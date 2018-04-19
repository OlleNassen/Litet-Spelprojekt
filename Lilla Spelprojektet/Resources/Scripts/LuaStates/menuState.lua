require("Resources/Scripts/Entity")

local p = Entity:create() -- player
p.texture = newTexture("Resources/Sprites/Player/playerDiffuse.png")


local cam = newSprite(1, 1, 0, p.texture)


local play = Entity:create() 
play.texture = newTexture("Resources/Sprites/play.png")
play.sprite = newSprite(800,100, 0, play.texture)
play:setPosition(-400,-300)

local editor = Entity:create() 
editor.texture = newTexture("Resources/Sprites/editor.png")
editor.sprite = newSprite(800,100, 0, editor.texture)
editor:setPosition(-400,-150)

local exit = Entity:create() 
exit.texture = newTexture("Resources/Sprites/quit.png")
exit.sprite = newSprite(800,100, 0, exit.texture)
exit:setPosition(-400,-0)

local s = Entity:create() 
s.texture = newTexture("Resources/Sprites/menu.png")
s.sprite = newSprite(1280,720, 0, s.texture)
s:setPosition(-1280/2, -720/2)

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

function update(deltaTime)

end