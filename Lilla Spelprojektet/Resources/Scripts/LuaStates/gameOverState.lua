require("Resources/Scripts/Entity")

local s = Entity:create() 
s.texture = newTexture("Resources/Sprites/gameover.png")

local cam = newSprite(0, 0, 0, s.texture)

s.sprite = newSprite(1280,720, 0, s.texture)
s:setPosition(-1280/2, -720/2)

timer = 0.0

function update(deltaTime)

	timer = timer + deltaTime
	
	if timer > 2.0 then
		clear()
	end

	return true
end