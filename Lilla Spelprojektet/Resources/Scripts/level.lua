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

mapSizeX = 0
mapSizeY = 0
tileMap = {}
function createTileMap(sizeX, sizeY)
	mapSizeX = sizeX
	mapSizeY = sizeY
	for y = 0, sizeY do
		for x = 0, sizeX do
			tempTile = createTile(x, y, 0)
			print(tempTile)
			tileMap[sizeX * y + x] = tempTile
		end
	end
end

function createTile(x, y, type)
	position = {x, y}
	tempTile = Tile:create(position, type)
	return tempTile
end

function loadFromFile(file)
	local file = io.open(file)
	index = 0
	if file then
		for line in file:lines() do
			local posX, posY, type = unpack(line:split(","))
			tileMap[index] = createTile(posX, posY, type)
			index = index + 1
		end
	end
end