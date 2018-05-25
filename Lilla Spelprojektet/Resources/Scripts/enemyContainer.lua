enemies = {}

function addEnemy(posX, posY, sizeX, sizeY, level)
	local enemy = Ai:create(posX, posY, sizeX, sizeY) -- goomba
	enemy.entity:addWorld(level)
	table.insert(enemies, enemy)
end

local enemyHitBuffer = newSoundBuffer("Resources/Sound/hit34.mp3.flac")
local enemyHitSound = newSound(enemyHitBuffer)

function updateEnemies(player, deltaTime)

	--Enemy loop (only works if enemies are added to state!)
	for i, enemy in ipairs(enemies) do
		enemy:update(deltaTime)
		enemy:attack(player)

		--Regular attack (right and left resp.)
		if player.isAttacking and player.releaseCharge == false and player.entity.currentAnimationIndex == 6 then
			if player.entity.isGoingRight == true then
				if enemy.entity:contains(player.entity.x + player.entity.width - 50, player.entity.y + (player.entity.height / 2)) == true then
					enemy.entity:takeDamage(player.attackDamage, player.attackPushBack.x, player.attackPushBack.y, true)
					playSound(enemyHitSound)
				end

			elseif player.entity.isGoingRight == false then
				if enemy.entity:contains(player.entity.x + 50, player.entity.y + (player.entity.height / 2)) == true then
					enemy.entity:takeDamage(player.attackDamage, player.attackPushBack.x, player.attackPushBack.y, true)
					playSound(enemyHitSound)
				end

			end
		end

		--Charge attack (right and left resp.)
		if player.isAttacking and player.releaseCharge and player.entity.currentAnimationIndex == 35  then

			if player.isAttacking == true and player.entity.isGoingRight == true then
				if enemy.entity:contains(player.entity.x + player.entity.width - 60, player.entity.y + (player.entity.height / 2)) == true then
					enemy.entity:takeDamage(player.attackDamage * 5, player.attackPushBack.x, player.attackPushBack.y, true)
					playSound(enemyHitSound)
				end

			elseif  player.isAttacking == true and player.entity.isGoingRight == false then
				if enemy.entity:contains(player.entity.x + 60, player.entity.y + (player.entity.height / 2)) == true then
					enemy.entity:takeDamage(player.attackDamage * 5, player.attackPushBack.x, player.attackPushBack.y, true)
					playSound(enemyHitSound)
				end

			end

		end

	end

end
