require("Resources/Scripts/Entity")

local p = Entity:create() -- player
p.texture = newTexture("Resources/Sprites/Player/playerDiffuse.png")

local cam = newSprite(1, 1, 0, p.texture)


local s = Entity:create() 
s.texture = newTexture("Resources/Sprites/gameover.png")
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