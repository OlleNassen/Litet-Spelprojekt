#include "particle_emitter.hpp"

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

//Accessors

//Modifiers