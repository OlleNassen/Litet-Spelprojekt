
texture = newTexture("Resources/Sprites/gameover.png")
sprite = newSprite(texture)
spritePos(sprite, 3000, 3000)

timer = 0.0

function update(deltaTime)

	timer = timer + deltaTime
	
	if timer > 1.0 then
		clear()
	end

	return true
end