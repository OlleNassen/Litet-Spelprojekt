p = position.new()
position.setPosition(p, 5, 5)

function moveUp(direction, deltaTime)
	position.move(p, 0, direction * 10 * deltaTime)
	return true
end

function moveRight(direction, deltaTime)
	position.move(p, direction * 10 * deltaTime, 0)
	return true
end

function jump()
	position.move(p, 0, -20)
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

function update(deltaTime)
	x, y = position.getPosition(p)
	position.move(p, 0, y * 100 * deltaTime)
	
	return true
end