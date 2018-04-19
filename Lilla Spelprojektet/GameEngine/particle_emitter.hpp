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
		Particle(glm::vec2 velocity, float lifeTimeMax)
		{
			this->velocity = velocity;
			this->lifeTimeMax = lifeTimeMax;
			this->lifeTime = this->lifeTimeMax;
		}

		glm::vec2 velocity;
		glm::vec2 position;
		float lifeTimeMax;
		float lifeTime;
	};

	std::vector<Particle> particles;
	Sprite* particle;

	//Private functions

public:
	//Con & Des
	ParticleEmitter(
		Shader* shader, 
		Texture2D* texture, 
		Texture2D* normalMap = nullptr, 
		const glm::vec2& size = glm::vec2(10, 10));

	virtual ~ParticleEmitter();

	//Functions
	void update();
	void render(const glm::mat4& view, const glm::mat4& projection);

	//Accessors

	//Modifiers

};

