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
	const glm::vec2& size)
{
	this->particle = new Sprite(shader, texture, normalMap, size);
}

ParticleEmitter::~ParticleEmitter()
{
	delete this->particle;
}


//Operators

//Functions
void ParticleEmitter::update()
{

}

void ParticleEmitter::render(const glm::mat4& view, const glm::mat4& projection)
{
	for (size_t i = 0; i < this->particles.size(); i++)
	{
		this->particle->draw(this->particles[i].position, view, projection);
	}
}

//Accessors

//Modifiers