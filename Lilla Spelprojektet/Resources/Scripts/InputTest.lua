p = position.new()
position.setPosition(p, 5, 5)

function moveUp(direction, deltaTime)
	position.move(0, direction * 5)
	return true
end

function moveRight(direction, deltaTime)
	position.move(direction * 5, 0)
	return true
end

function jump()
	position.move(20, 0)
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