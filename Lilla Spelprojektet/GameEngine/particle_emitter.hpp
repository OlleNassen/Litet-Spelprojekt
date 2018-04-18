#pragma once

#include"../libs.h"
#include"../Renderer/sprite.hpp"
#include"../Renderer/shader.hpp"

class ParticleEmitter
{
private:
	std::vector<glm::vec2> particle_positions;
	Sprite* particle;

public:
	ParticleEmitter(
		Shader* shader, 
		Texture2D* texture, 
		Texture2D* normalMap = nullptr, 
		const glm::vec2& size = glm::vec2(48, 48));

	virtual ~ParticleEmitter();
};

