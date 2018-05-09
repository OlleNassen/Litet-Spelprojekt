Background = {}
Background.__index = Background

function Background:create()
    local this =
    {
		texture,
		normalMap,
		sprite,
		x = 0,
		y = 0,
    }

    setmetatable(this, self)
    return this
end

function Background:setPosition(x, y, i)
	
	self.x = x
	self.y = y
		
	if self.sprite ~= nil then
		backgroundPos(self.sprite, self.x, self.y, i)		
	end
end

function Background:getPosition()

	return self.x, self.y
end

function Background:move(x, y)
	
	self.x = self.x + x
	self.y = self.y + y
		
	if self.sprite ~= nil then
		backgroundPos(self.sprite, self.x, self.y)		
	end
end
