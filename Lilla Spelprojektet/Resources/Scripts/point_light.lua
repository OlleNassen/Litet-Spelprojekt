PointLight = {}
PointLight.__index = PointLight

function PointLight:create(red, green, blue, x, y)
    
	if normal ~= 0 then
		t = newTexture("Resources/Sprites/lamp_normal.png")
	else
		t = 0
	end
	
	local this =
    {
		normaltext = t,
		diffusetext = newTexture("Resources/Sprites/lamp_diffuse.png"),
		sprite
    }
	this.sprite = newLight(red, green, blue, x, y, this.normaltext, this.diffusetext)

    setmetatable(this, self)
    return this
end

