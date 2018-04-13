require("Resources/Scripts/Entity")

local s = Entity:create() 
s.texture = newTexture("Resources/Sprites/menu.png")

local cam = newSprite(0, 0, 0, s.texture)

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

function update(deltaTime)
	print ("Press enter to start!")
end