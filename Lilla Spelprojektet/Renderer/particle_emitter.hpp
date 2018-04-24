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

		void update(const float& dt)
		{
			if (this->lifeTime > 0.f)
			{
				this->lifeTime -= 100 * dt;
				this->position.x += (rand()% (static_cast<int>(this->velocity.x)+1)) * dt;
				this->position.y += (rand() % (static_cast<int>(this->velocity.y) + 1)*2 - (static_cast<int>(this->velocity.y) + 1)) * dt;
			}
		}
	};

	std::vector<Particle> particles;
	Sprite* particle;
	glm::vec2 velocity;
	float lifeTime;

	//Private functions

public:
	//Con & Des
	ParticleEmitter(
		Shader* shader,
		Texture2D* texture,
		Texture2D* normalMap,
		const glm::vec2& size = glm::vec2(0, 0),
		const glm::vec2& velocity = glm::vec2(0.f, 0.f),
		const float& lifeTime = 0.f);

	virtual ~ParticleEmitter();

	//Functions
	void push(const unsigned& amount, const float&x, const float&y);
	void update(const float& dt);
	void render(const glm::mat4& view, const glm::mat4& projection, const float& dt);

	//Accessors

	//Modifiers

};

