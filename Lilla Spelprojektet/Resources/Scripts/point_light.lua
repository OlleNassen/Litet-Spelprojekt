PointLight = {}
PointLight.__index = PointLight

function PointLight:create(red, green, blue, x, y, normal, diffuse)
    
	local this =
    {
		normaltext = newTexture(normal),
		diffusetext = newTexture(diffuse),
		sprite
    }
	this.sprite = newLight(red, green, blue, x, y, this.normaltext, this.diffusetext)

    setmetatable(this, self)
    return this
end

