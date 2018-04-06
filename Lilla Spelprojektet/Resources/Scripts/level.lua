--todo: implement a level system importing tiles:

require("/Resources/Scripts/tile")

position = {3,4}
test = Tile:create(position)

test:print()

function update(deltaTime)
	print ("Du gjorde fel")
end

tileMap = {}
for x = 0, 100 do
		tileTemp = Tile:create(position)
		xVal = tileMap[x] (x % 10) * 48
		yVal = tileMap[x]:getSize().height * (x / 10) * 48
		position = {xVal, yVal}
		print(tileMap[x])
end