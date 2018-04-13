
t = newTexture("Resources/Sprites/HansTap.png")
s = newSprite(t)

function moveUp(direction, deltaTime)
	p:move(direction * p.speed * deltaTime, 0)
end

function moveRight(direction, deltaTime)
	p:move(direction * p.speed * deltaTime, 0)
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