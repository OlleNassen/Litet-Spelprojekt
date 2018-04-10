require("Resources/Scripts/player")
require("Resources/Scripts/goomba")

local p = Player:create(50,50) -- player

local g = Goomba:create(300,300) -- goomba

function moveUp(direction, deltaTime)
	--position.move(p, 0, direction * 25 * deltaTime)
	return true
end

function moveRight(direction, deltaTime)
	p:move(direction * p.speed * deltaTime, 0)
	return true
end

isJumping = false

function jump()
	isJumping = true
end

function playerPosition()
	return position.getPosition(p.position)
end

function goombaPosition()
	return position.getPosition(g.position)
end

function input3()
	rebind("input4", false)
end

function input4()
	print ("input4")
end

function mouse(x, y)
	--print (x)
	--print (y)
end

timeSinceJump = 0.0

function update(deltaTime)

	if isJumping then
		
		timeSinceJump = timeSinceJump + deltaTime
		p:move(0, -100 * deltaTime)
		
		if timeSinceJump > 1.0 then
			isJumping = false
			timeSinceJump = 0.0
		end
	else
		p:move(0, 100 * deltaTime)

	end

		g:move(0, 100 * deltaTime)


	if math.random() > 0.5 then
		g:move(100 * deltaTime, 0)
	else
		g:move(-100 * deltaTime, 0)
	end
	return true
end