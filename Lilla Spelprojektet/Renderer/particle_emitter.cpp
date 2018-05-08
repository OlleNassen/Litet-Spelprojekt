#include "particle_emitter.hpp"

#define BUFFER_OFFSET(i) ((char *)nullptr + (i))
#include<glm/gtc/matrix_transform.hpp>
#include<glm/gtc/type_ptr.hpp>

#include <sstream>
#include <string>

ParticleEmitter::ParticleEmitter(Shader* shader, Texture2D* diffuse, Texture2D* normalMap)
{

	computeShader.load("Resources/Shaders/shader.comp");

	this->shader = shader;

	this->texture = diffuse;

	this->normalMap = normalMap;

	shader->setInt(0, "diffuseMap");
	shader->setInt(1, "normalMap");

	this->particles.globalVelocity = glm::vec2(5.f, 3.f);
	/*
		float offset = 0.1f;
		for (int y = -10; y < 10; y += 2)
		{
			for (int x = -10; x < 10; x += 2)
			{
				glm::vec2 translation;
				translation.x = (float)x / 10.0f + offset;
				translation.y = (float)y / 10.0f + offset;

				push(1, translation.x, translation.y);

			}
		}
	*/
	
	
	initParticleEmitter();
}

ParticleEmitter::~ParticleEmitter()
{
}

void ParticleEmitter::render(const glm::mat4& view, const glm::mat4& projection)
{
	this->shader->setMatrix4fv(model, "model");
	this->shader->setMatrix4fv(view, "view");
	this->shader->setMatrix4fv(projection, "projection");


	

	texture->bind(0);
	normalMap->bind(1);

	shader->use();


	glBindVertexArray(VAO);

	glBindBuffer(GL_ARRAY_BUFFER, instanceVBO);
	glBufferData(GL_ARRAY_BUFFER, MAX_NUM_PARTICLES * sizeof(glm::vec2), &particleStruct->positions[0], GL_STATIC_DRAW);

	glDrawArraysInstanced(GL_TRIANGLES, 0, 6, MAX_NUM_PARTICLES);
	glBindVertexArray(0);

}

void ParticleEmitter::update(float dt, const glm::vec2& position)
{
	// Prepare transformations
	model = glm::mat4(1.f);
	model = glm::translate(model, glm::vec3(position, 0.0f));

	model = glm::translate(model, glm::vec3(0.5f * 48.f, 0.5f * 48.f, 0.0f));
	model = glm::rotate(model, 0.f, glm::vec3(0.0f, 0.f, 0.1f));
	model = glm::translate(model, glm::vec3(-0.5f * 48.f, -0.5f * 48.f, 0.0f));

	model = glm::scale(model, glm::vec3(256.f, 256.f, 1.0f));
	
	/*
	for (auto& translation : particles.translations)
	{
		translation.y-= 0.0016;
	}
	*/
	//FIX


	for (int i = 0; i < MAX_NUM_PARTICLES; i++)
	{
		if (particles.timeLeft[i] > 0.f)
		{
			particles.timeLeft[i] -= 100 * dt;
			particles.translations[i].x += (rand() % (static_cast<int>(particles.globalVelocity.x) + 1)) * dt;
			particles.translations[i].y += (rand() % (static_cast<int>(particles.globalVelocity.y) + 1) * 2 - (particles.globalVelocity.y) + 1) * dt;
		}

		else
		{
			particles.first = (particles.first + 1) % MAX_NUM_PARTICLES;

			particles.translations[i] = glm::vec2(-9999, -9999);
			particles.timeLeft[i] = -1;

			particles.exists[i] = false;
		}

	}
	
}

void ParticleEmitter::updateLaser(float dt, const glm::vec2 & position, const glm::vec2 pixiePos)
{
	particleStruct = computeShader.compute(position, pixiePos);

	// Prepare transformations
	model = glm::mat4(1.f);
	model = glm::translate(model, glm::vec3(position, 0.0f));

	//model = glm::scale(model, glm::vec3(48.f, 48.f, 1.0f));

	/*
	glm::vec2 direction = glm::normalize(pixiePos - position);

	for (int i = 0; i < MAX_NUM_PARTICLES; i++)
	{
		if (particles.timeLeft[i] > 0.f)
		{
			float multiple = 5000.f;

			glm::vec2 particlePos = model * 
				glm::vec4(particles.translations[i].x, 
						  particles.translations[i].y, 
						  1.0f, 1.0f);

			float length = glm::length(pixiePos - position);
			float length2 = glm::length(particlePos - position);

			if (length2 > length)
			{
				particles.translations[i] = glm::vec2(0,0);
			}
			else
			{

				particles.translations[i] += direction * multiple * dt;
			}
				
		}
		else
		{
			particles.first = (particles.first + 1) % MAX_NUM_PARTICLES;

			particles.translations[i] = glm::vec2(-9999, -9999);
			particles.timeLeft[i] = -1;

			particles.exists[i] = false;
		}
		particles.timeLeft[i] -= 100 * dt;
	}
	*/
}

void ParticleEmitter::push(unsigned int amount, float x, float y)
{
	if (particles.first != particles.last)
	{
		for (int i = 0; i < amount; i++)
		{
			particles.translations[particles.last] = glm::vec2(x, y);
			particles.timeLeft[particles.last] = particles.globalTimeLeft;
			particles.exists[particles.last] = true;
			particles.last = (particles.last + 1) % MAX_NUM_PARTICLES;

		}
	}
	
}

void ParticleEmitter::removeParticles()
{
}

void ParticleEmitter::initParticleEmitter()
{
	glGenBuffers(1, &instanceVBO);
	glBindBuffer(GL_ARRAY_BUFFER, instanceVBO);
	glBufferData(GL_ARRAY_BUFFER, sizeof(glm::vec2) * MAX_NUM_PARTICLES, &particles.translations[0], GL_STATIC_DRAW);
	glBindBuffer(GL_ARRAY_BUFFER, 0);

	float quadVertices[] = {
		// positions //Texcoords     // colors
		0.f,  12.f, 0.0f, 1.0f,  1.0f, 0.0f, 0.0f,
		12.f, 0.f, 1.0f, 0.0,  0.0f, 1.0f, 0.0f,
		0.f, 0.f, 0.0f, 0.0f,  0.0f, 0.0f, 1.0f,

		0.f,  12.f, 0.0f, 1.0f,  1.0f, 0.0f, 0.0f,
		12.f, 0.f, 1.0f, 1.0f,  0.0f, 1.0f, 0.0f,
		12.f,  12.f, 1.0f, 0.0f,  0.0f, 1.0f, 1.0f
	};

	glGenVertexArrays(1, &VAO);
	glGenBuffers(1, &VBO);
	glBindVertexArray(VAO);
	glBindBuffer(GL_ARRAY_BUFFER, VBO);
	glBufferData(GL_ARRAY_BUFFER, sizeof(quadVertices), quadVertices, GL_STATIC_DRAW);

	int offset = 0;

	glEnableVertexAttribArray(0);
	glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 7 * sizeof(float), BUFFER_OFFSET(offset));
	offset += sizeof(float) * 2;

	glEnableVertexAttribArray(1);
	glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 7 * sizeof(float), BUFFER_OFFSET(offset));
	offset += sizeof(float) * 2;

	glEnableVertexAttribArray(2);
	glVertexAttribPointer(2, 3, GL_FLOAT, GL_FALSE, 7 * sizeof(float), BUFFER_OFFSET(offset));
	offset += sizeof(float) * 3;
	
	
	// also set instance data
	offset = 0;
	glEnableVertexAttribArray(3);
	glBindBuffer(GL_ARRAY_BUFFER, instanceVBO); // this attribute comes from a different vertex buffer
	glVertexAttribPointer(3, 2, GL_FLOAT, GL_FALSE, 2 * sizeof(float), BUFFER_OFFSET(offset));
	glBindBuffer(GL_ARRAY_BUFFER, 0);
	glVertexAttribDivisor(3, 1); // tell OpenGL this is an instanced vertex attribute.




}
