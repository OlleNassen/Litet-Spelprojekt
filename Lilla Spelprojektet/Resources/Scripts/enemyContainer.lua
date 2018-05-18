enemies = {}

function addEnemy(posX, posY, sizeX, sizeY, level)
	local enemy = Ai:create(posX, posY, sizeX, sizeY) -- goomba
	enemy.entity:addWorld(level)
	table.insert(enemies, enemy)
end

function updateEnemies(player, deltaTime)

	for i, enemy in ipairs(enemies) do
		enemy:update(deltaTime)
		enemy:attack(player)

		if player.isAttacking == true and player.entity.isGoingRight == true then
			if enemy.entity:contains(player.entity.x + player.entity.width - 50, player.entity.y + (player.entity.height / 2)) == true then
				enemy.entity:takeDamage(player.attackDamage, player.attackPushBack.x, player.attackPushBack.y, true)
			end

		elseif  player.isAttacking == true and player.entity.isGoingRight == false then
			if enemy.entity:contains(player.entity.x + 50, player.entity.y + (player.entity.height / 2)) == true then
				enemy.entity:takeDamage(player.attackDamage, player.attackPushBack.x, player.attackPushBack.y, true)
			end

		end

	end

end
