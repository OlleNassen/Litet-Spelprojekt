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

		if player.isAttacking == true then
			if enemy.entity:contains(player.entity.x + player.entity.width, player.entity.y + (player.entity.height / 2)) == true then
				enemy.entity:takeDamage(player.attackDamage, player.attackPushBack.x, player.attackPushBack.y, true)
			end
		end

	end

end
