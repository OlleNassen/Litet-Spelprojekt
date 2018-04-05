print("Hello from lua")

x = 10
y = 50

function getPosition()
	return x, y
end

function input1(direction, deltaTime)
	print ("input1")
	x = x + direction
	return true
end