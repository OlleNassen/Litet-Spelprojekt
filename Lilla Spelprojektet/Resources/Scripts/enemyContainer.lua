enemies = {}

function addEnemy(posX, posY, sizeX, sizeY, level)
	local enemy = Ai:create(posX, posY, sizeX, sizeY) -- goomba
	enemy.entity:addWorld(level)
	table.insert(enemies, enemy)
end

function updateEnemies(player, deltaTime)

	--Enemy loop (only works if enemies are added to state!)
	for i, enemy in ipairs(enemies) do
		enemy:update(deltaTime)
		enemy:attack(player)

		--Regular attack (right and left resp.)
		if player.isAttacking and player.releaseCharge == false then
			if player.entity.isGoingRight == true then
				if enemy.entity:contains(player.entity.x + player.entity.width - 50, player.entity.y + (player.entity.height / 2)) == true then
					enemy.entity:takeDamage(player.attackDamage, player.attackPushBack.x, player.attackPushBack.y, true)
				end

			elseif player.entity.isGoingRight == false then
				if enemy.entity:contains(player.entity.x + 50, player.entity.y + (player.entity.height / 2)) == true then
					enemy.entity:takeDamage(player.attackDamage, player.attackPushBack.x, player.attackPushBack.y, true)
				end

			end
		end

		--Charge attack (right and left resp.)
		if player.isAttacking and player.releaseCharge then
		
			print("CHARGE ATTACK!")
			player.releaseCharge = false

			if player.isAttacking == true and player.entity.isGoingRight == true then
				if enemy.entity:contains(player.entity.x + player.entity.width - 30, player.entity.y + (player.entity.height / 2)) == true then
					enemy.entity:takeDamage(player.attackDamage * 5, player.attackPushBack.x, player.attackPushBack.y, true)
				end

			elseif  player.isAttacking == true and player.entity.isGoingRight == false then
				if enemy.entity:contains(player.entity.x + 30, player.entity.y + (player.entity.height / 2)) == true then
					enemy.entity:takeDamage(player.attackDamage * 5, player.attackPushBack.x, player.attackPushBack.y, true)
				end

			end

		end

	end

end
