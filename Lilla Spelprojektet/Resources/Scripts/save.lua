Save = {}
Save.__index = Save

local localLoad = loadData
local localSave = saveData

local powerup = {}

function getUpgrade(name)

	for k, v in pairs(powerup) do
		if powerup[id] == name then
			return id
		end
	end
	return -1
end

function setUpgrade(name, id)

	powerup[id] = name

end


function getRoomId()
	
	return localLoad(0)

end

function setRoomId(id)
	
	return localSave(0, id)

end