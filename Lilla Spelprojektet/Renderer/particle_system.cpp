#include "particle_system.hpp"

#define BUFFER_OFFSET(i) ((char *)nullptr + (i))
#include<glm/gtc/matrix_transform.hpp>
#include<glm/gtc/type_ptr.hpp>

#include <sstream>
#include <string>

ParticleSystem::ParticleSystem(Shader* shader, Texture2D* diffuse, Texture2D* normalMap)
{

	this->shader = shader;

	this->texture = diffuse;

	this->particles.globalVelocity = glm::vec2(18.f, 20.f);

	//push(5000, 0, 0);

	static int ab = 0;
	static int ac = 0;

	for (int i = 0; i < 500; i++)
	{
		float offset = 0.1f;
		for (int y = -10; y < 10; y += 2)
		{
			for (int x = -10; x < 10; x += 2)
			{
				glm::vec2 translation;
				translation.x = (float)x / 10.0f + offset + ab;
				translation.y = (float)y / 10.0f + offset + ac;

				ab += 0.01;
				ac += 0.01;


				push(1, translation.x, translation.y);

			}
		}
	}
	
	
	
	initParticleSystem();
}

ParticleSystem::~ParticleSystem()
{
}

void ParticleSystem::render(const glm::mat4& view, const glm::mat4& projection)
{
	this->shader->setMatrix4fv(model, "model");
	this->shader->setMatrix4fv(view, "view");
	this->shader->setMatrix4fv(projection, "projection");

	texture->bind(0);

	shader->use();
	glBindVertexArray(VAO);

	glBindBuffer(GL_ARRAY_BUFFER, instanceVBO);
	glBufferData(GL_ARRAY_BUFFER, maxNumParticles * sizeof(glm::vec2), &particles.translations[0], GL_STREAM_DRAW);

	glDrawArraysInstanced(GL_TRIANGLES, 0, 6, maxNumParticles);
	glBindVertexArray(0);

}

void ParticleSystem::update(float dt)
{
	glm::vec2 position(0, 0);
	// Prepare transformations
	model = glm::mat4(1.f);
	model = glm::translate(model, glm::vec3(position, 0.0f));

	model = glm::translate(model, glm::vec3(0.5f * 48.f, 0.5f * 48.f, 0.0f));
	model = glm::rotate(model, 0.f, glm::vec3(0.0f, 0.f, 0.1f));
	model = glm::translate(model, glm::vec3(-0.5f * 48.f, -0.5f * 48.f, 0.0f));

	model = glm::scale(model, glm::vec3(256.f, 256.f, 1.0f));
	
	for (auto& translation : particles.translations)
	{
		translation.y-= 0.0016;
	}
	
	//FIX
	
	std::cout << particles.numParticles << '\n';

	for (int i = 0; i < particles.numParticles; i++)
	{
		if (this->particles.timeLeft[i] >= 0)
		{
			for (int i = 0; i < particles.translations.size(); i++)
			{
				if (particles.timeLeft[i] > 0.f)
				{
					particles.timeLeft[i] -= 100 * dt;
					particles.translations[i].x += (rand() % (static_cast<int>(particles.globalVelocity.x) + 1)) * dt;
					particles.translations[i].y += (rand() % (static_cast<int>(particles.globalVelocity.y) + 1) * 2 - (particles.globalVelocity.y) + 1) * dt;
				}

			}
		}
		/*
		else
		{

			particles.translations.erase(particles.translations.begin() + i);
			particles.timeLeft.erase(particles.timeLeft.begin() + i);
		}
		*/
		
	}
	
	
}

void ParticleSystem::push(unsigned int amount, float x, float y)
{
	if (particles.numParticles < maxNumParticles)
	{
		for (size_t i = 0; i < amount; i++)
		{
			particles.translations.push_back(glm::vec2(x, y));
			particles.timeLeft.push_back(particles.globalTimeLeft);

			particles.numParticles++;
		}
	}
}

void ParticleSystem::removeParticles()
{
}

void ParticleSystem::initParticleSystem()
{
	glGenBuffers(1, &instanceVBO);
	glBindBuffer(GL_ARRAY_BUFFER, instanceVBO);
	glBufferData(GL_ARRAY_BUFFER, sizeof(glm::vec2) * maxNumParticles, &particles.translations[0], GL_STREAM_DRAW);
	glBindBuffer(GL_ARRAY_BUFFER, 0);

	float quadVertices[] = {
		// positions //Texcoords     // colors
		-0.05f,  0.05f, 0.0f, 1.0f,  1.0f, 0.0f, 0.0f,
		0.05f, -0.05f, 1.0f, 0.0,  0.0f, 1.0f, 0.0f,
		-0.05f, -0.05f, 0.0f, 0.0f,  0.0f, 0.0f, 1.0f,

		-0.05f,  0.05f, 0.0f, 1.0f,  1.0f, 0.0f, 0.0f,
		0.05f, -0.05f, 1.0f, 1.0f,  0.0f, 1.0f, 0.0f,
		0.05f,  0.05f, 1.0f, 0.0f,  0.0f, 1.0f, 1.0f
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
