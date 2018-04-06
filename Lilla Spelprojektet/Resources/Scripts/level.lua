--todo: implement a level system importing tiles:

require("/Resources/Scripts/tile")

position = {3,4}
test = Tile:create(position)

test:print()

function update(deltaTime)
	print ("Du gjorde fel")
end

tileMap = {}
for x = 0, 20 do
    tileMap[x] = {}
    for y = 0, 25 do
		tileMap[x][y] = Tile:create(position)
		xVal = tileMap[x][y]:getSize().x * x
		yVal = tileMap[x][y]:getSize().y * y
		position = {xVal, yVal}
		print(tileMap[x][y])
    end
end