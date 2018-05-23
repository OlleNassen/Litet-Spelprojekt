function mouseLeft()
	return p:attack()
end

function mouseRight()
	return p:chargeAttack()
end

function moveUp(direction, deltaTime)
	return p:moveUp(direction, deltaTime)
end

function moveRight(direction, deltaTime)
	return p:moveRight(direction, deltaTime)
end

function dash()
	if p.canDash == true and p.entity.hasPowerUp[1] == true then --Activate dash
		p.entity.collision_bottom = false
		p.dashing = true
		p.canDash = false
	end
end

function jump()
	return p:jump()
end

function fly()
	return p:fly()
end

mX = 0.0
mY = 0.0

function mouse(x, y)
	mX = mX + x
	mY = mY + y
end

local bLaserOn = false
function laser()
	if p.entity.hasPowerUp[5] == true then
		if bLaserOn == false and p.laserPower >= 20 then
			laserOn()
			bLaserOn = true
		elseif bLaserOn then
			laserOff()
			bLaserOn = false	
		end
	end
end

-- PowerUps
-- Dash
local towardsX = 0
local towardsY = 0
local hasFoundPosition = false

function checkUpgrades(deltaTime)
	if p.entity.hasPowerUp[1] == true then -- DASH UPGRADE
	
		--[[if p.entity.collision_bottom == true then --Cant dash until on ground
			p.canDash = true
		end

		if p.dashing == true then --Dashing
			p.entity.hasGravity = false
			p.canDash = false
			if hasFoundPosition == false then
				towardsX = s.x
				towardsY = s.y
				hasFoundPosition = true
			end

			local tempX = towardsX - p.entity.x 
			local tempY = towardsY - p.entity.y 
			local length = math.sqrt((tempX * tempX) + (tempY * tempY))
			tempX = (tempX / length)
			tempY = (tempY / length)
	
			p.entity.velocity.x = tempX * 2000
			p.entity.velocity.y = tempY * 2000


			--Dashing ends
			if length < 30 or p.entity.collision_top == true or  p.entity.collision_left == true or p.entity.collision_right == true or p.entity.collision_bottom == true then
				p.dashing = false
				p.entity.hasGravity = true
				hasFoundPosition = false
				p.entity.velocity.x = p.entity.velocity.x / 5
				p.entity.velocity.y = p.entity.velocity.y / 5
			end
		end]]

		if p.entity.collision_bottom == true then --Cant dash until on ground
			p.canDash = true
		end

		if p.dashing == true then --Dashing
			p.entity.hasGravity = false
			p.canDash = false

			if hasFoundPosition == false then
				posFrom = {x, y}
				posFrom.x = p.entity.x
				posFrom.y = p.entity.y
				posTo = {x, y}
				posTo.x = s.x
				posTo.y = s.y
				hasFoundPosition = true
			end
			
			local distance = math.sqrt((posFrom.x - posTo.x) * (posFrom.x - posTo.x) + (posFrom.y - posTo.y) * (posFrom.y - posTo.y))
			movePos = {x, y}
			movePos.x = (posTo.x - posFrom.x) / distance
			movePos.y = (posTo.y - posFrom.y) / distance
			print(movePos.x, movePos.y)

			p.entity.velocity.x = movePos.x * 100000 * deltaTime
			p.entity.velocity.y = movePos.y * 100000 * deltaTime

			distance = math.sqrt((posFrom.x - p.entity.x) * (posFrom.x - p.entity.x) + (posFrom.y - p.entity.y) * (posFrom.y - p.entity.y))
			if distance > 200 or p.entity.collision_top == true or  p.entity.collision_left == true or p.entity.collision_right == true or p.entity.collision_bottom == true then
				p.dashing = false
				p.entity.hasGravity = true
				hasFoundPosition = false
				p.entity.velocity.x = p.entity.velocity.x / 5
				p.entity.velocity.y = p.entity.velocity.y / 5
			end
		end
	end
	if p.entity.hasPowerUp[2] == true then -- SPEED UPGRADE
		p.entity.maxSpeed.x = 800
	else
		p.entity.maxSpeed.x = 500
	end
	if p.entity.hasPowerUp[3] == true then -- DOUBLE JUMP UPGRADE
		p.maxNrOfJumps = 2
	else
		p.maxNrOfJumps = 1
	end
	if p.entity.hasPowerUp[4] == true then -- HIGH JUMP UPGRADE
		p.jumpPower = -1500
	else
		p.jumpPower = -1300
	end
	if p.entity.hasPowerUp[5] == true then
		laserDamage(deltaTime)
	end
end

local laserLerpTime = 0
function laserDamage(deltaTime)
	if p.laserPower <= 0 then
		bLaserOn = false
		laserOff()
	end

	if bLaserOn and #enemies > 0 then
		posFrom = {x, y}
		posFrom.x = p.entity.x
		posFrom.y = p.entity.y
		posTo = {x, y}
		posTo.x = s.x
		posTo.y = s.y

		laserPos = {x, y}
		laserLerpTime = laserLerpTime + deltaTime
		laserPos = Lerp(posFrom, posTo, laserLerpTime)
		if laserLerpTime >= 1 then
			laserLerpTime = 0
		end

		for i, enemy in ipairs(enemies) do
			if enemy.entity:contains(laserPos.x, laserPos.y) == true then
				enemy.entity:takeDamage(p.attackDamage, p.attackPushBack.x, p.attackPushBack.y, true)
			end
		end

		if p.laserPower > 0 then
			p.laserPower = p.laserPower - (deltaTime * 20)
			p:updateLaserBar()
		end
	elseif bLaserOn == false and p.entity.hasPowerUp[5] then
		if p.laserPower < 100 then
			p.laserPower = p.laserPower + (deltaTime * 4)
			p:updateLaserBar()

			if p.laserPower > 100 then
				p.laserPower = 100
			end
		end
	end
end