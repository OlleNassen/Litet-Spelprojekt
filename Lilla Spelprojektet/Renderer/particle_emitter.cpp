#include "particle_emitter.hpp"
#include"../Renderer/sprite.hpp"
#include"../Renderer/shader.hpp"

//Static variables

//Static functions

//Private functions

//Con & Des
ParticleEmitter::ParticleEmitter(
	Shader* shader, 
	Texture2D* texture, 
	Texture2D* normalMap,
	const glm::vec2& origin,
	const glm::vec2& size,
	const glm::vec2& velocity,
	const float& lifeTime)
{
	this->particle = new Sprite(shader, texture, normalMap, size);
	this->velocity = velocity;
	this->lifeTime = lifeTime;
	this->origin = origin;

	for (size_t i = 0; i < 1; i++)
	{
		this->particles.push_back(Particle(this->origin, this->velocity, this->lifeTime));
	}
}

ParticleEmitter::~ParticleEmitter()
{
	delete this->particle;
}

//Operators

//Functions
void ParticleEmitter::update(const float& dt)
{
	for (size_t i = 0; i < this->particles.size(); i++)
	{
		if (this->particles[i].lifeTime >= 0)
			particles[i].update(dt);
	}
}

void ParticleEmitter::render(const glm::mat4& view, const glm::mat4& projection)
{
	for (size_t i = 0; i < this->particles.size(); i++)
	{
		this->particle->update(this->particles[i].position);
		this->particle->draw(this->particles[i].position, view, projection);
	}
}

//Accessors

//Modifiers