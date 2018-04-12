
--texture = newTexture("Resources/Sprites/gameover.png")
--sprite = newSprite(texture)
--spritePos(sprite, 1200 - 96, 864 - 96)

timer = 0.0

function update(deltaTime)

	timer = timer + deltaTime
	
	if timer > 1.0 then
		clear()
	end
end