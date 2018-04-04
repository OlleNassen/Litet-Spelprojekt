function input1(direction, deltaTime)
	print ("input1")
	return true
end

function input2()
	print ("input2")
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