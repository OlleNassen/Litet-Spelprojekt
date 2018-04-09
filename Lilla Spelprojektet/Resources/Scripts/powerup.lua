--Todo: Finish

Powerup = {}
Powerup.__index = Powerup

function Powerup:create()
   local powerup = {}

   --Tile size:
	powerup.has = false

   setmetatable(powerup,Powerup)

   return powerup
end

function Powerup:setHas()
	this.has = true
end

function DoubleJump( Powerup )

    local new_class = {}
    local class_mt = { __index = new_class }

    function new_class:create()
        local newinst = {}
        setmetatable( newinst, class_mt )
        return newinst
    end

    if nil ~= baseClass then
        setmetatable( new_class, { __index = baseClass } )
    end