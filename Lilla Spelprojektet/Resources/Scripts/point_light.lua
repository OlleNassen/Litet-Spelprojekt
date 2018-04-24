PointLight = {}
PointLight.__index = PointLight

function PointLight:create(red, green, blue, x, y, normal, diffuse)
    
	if normal ~= 0 then
		t = newTexture(normal)
	else
		t = 0
	end
	
	
	local this =
    {
		normaltext = t,
		diffusetext = newTexture(diffuse),
		sprite
    }
	this.sprite = newLight(red, green, blue, x, y, this.normaltext, this.diffusetext)

    setmetatable(this, self)
    return this
end

