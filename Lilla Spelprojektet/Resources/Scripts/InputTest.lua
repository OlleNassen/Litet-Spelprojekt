p = position.new()
position.setPosition(p, 50, 50)

function moveUp(direction, deltaTime)
	--position.move(p, 0, direction * 25 * deltaTime)
	return true
end

function moveRight(direction, deltaTime)
	position.move(p, direction * 25 * deltaTime, 0)
	return true
end

isJumping = false

function jump()
	isJumping = true
end

function getPosition()
	return position.getPosition(p)
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
		position.move(p, 0, -100 * deltaTime)
		
		if timeSinceJump > 1.0 then
			isJumping = false
			timeSinceJump = 0.0
		end
	else
		position.move(p, 0, 100 * deltaTime)
	end
	
	return true
end