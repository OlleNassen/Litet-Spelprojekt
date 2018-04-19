#pragma once

#include<vector>
#include<glm/gtc/matrix_transform.hpp>
#include<glm/gtc/type_ptr.hpp>

class Shader;
class Texture2D;
class Sprite;

class ParticleEmitter
{
private:

	class Particle
	{
	public:

		glm::vec2 velocity;
		glm::vec2 position;
		float lifeTime;

		Particle(
			const glm::vec2& position, 
			const glm::vec2& velocity, 
			const float& lifeTime)
		{
			this->position = position;
			this->velocity = velocity;
			this->lifeTime = lifeTime;
		}

		void update(const float& dt, const glm::vec2& origin)
		{
			if (this->lifeTime > 0.f)
			{
				this->lifeTime -= 10 * dt;
				this->position += this->velocity * dt;
			}
		}
	};

	std::vector<Particle> particles;
	Sprite* particle;
	glm::vec2 velocity;
	float lifeTime;
	glm::vec2 origin;

	//Private functions

public:
	//Con & Des
	ParticleEmitter(
		Shader* shader,
		Texture2D* texture,
		Texture2D* normalMap,
		const glm::vec2& origin,
		const glm::vec2& size = glm::vec2(0, 0),
		const glm::vec2& velocity = glm::vec2(0.f, 0.f),
		const float& lifeTime = 0.f);

	virtual ~ParticleEmitter();

	//Functions
	void update(const float& dt, const glm::vec2& origin);
	void render(const glm::mat4& view, const glm::mat4& projection);

	//Accessors

	//Modifiers

};

