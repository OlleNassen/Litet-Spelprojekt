#include "temp_pixie.hpp"
#define BUFFER_OFFSET(i) ((char *)nullptr + (i))
#include <ctime>

PixieParticles::PixieParticles(Shader* shader, Texture2D* texture)
{
	srand(time(NULL));
	this->shader = shader;
	this->texture = texture;
	//compShader.load("Resources/Shaders/pixie.comp");
	//particleStruct = compShader.pixie(glm::vec2(0,0));
	for (int i = 0; i < MAX_NUM_PARTICLES; i++)
	{
		offsets[i].x = 0;
		offsets[i].y = 0;
	}
	initPixie();
}

PixieParticles::~PixieParticles()
{

}

void PixieParticles::render(const glm::mat4& view, const glm::mat4& projection)
{
	this->shader->setMatrix4fv(model, "model");
	this->shader->setMatrix4fv(view, "view");
	this->shader->setMatrix4fv(projection, "projection");

	this->texture->bind(0);

	this->shader->use();

	glBindVertexArray(VAO);
	glDrawArraysInstanced(GL_TRIANGLES, 0, 6, MAX_NUM_PARTICLES);
	glBindVertexArray(0);

	this->shader->unuse();
}

void PixieParticles::update(const glm::vec2& pixiePos)
{
	model = glm::mat4(1.f);
	model = glm::translate(model, glm::vec3(pixiePos, 0.0f));

	for (int i = 0; i < MAX_NUM_PARTICLES; i++)
	{
		float angle = rand()*3.14f * 2;
		float radius = 24.f;
		offsets[i].x = std::cos(angle) * radius;
		offsets[i].y = std::sin(angle) * radius;
	}

	//particleStruct = compShader.pixie(pixiePos);

	glBindBuffer(GL_ARRAY_BUFFER, instanceVBO);
	glBufferData(GL_ARRAY_BUFFER, MAX_NUM_PARTICLES * sizeof(glm::vec2), (void*)offsets, GL_STATIC_DRAW);
}

void PixieParticles::initPixie()
{
	glGenBuffers(1, &instanceVBO);
	glBindBuffer(GL_ARRAY_BUFFER, instanceVBO);
	glBufferData(GL_ARRAY_BUFFER, sizeof(glm::vec2) * MAX_NUM_PARTICLES, (void*)offsets, GL_STATIC_DRAW);
	glBindBuffer(GL_ARRAY_BUFFER, 0);
	const float size = 8.f;
	float quadVertices[] = {
		// positions     // colors
		0.0f, size, 0.0f, 1.0f,  1.f, 1.f, 1.f,
		size, 0.0f, 1.0f, 0.0f,    1.f, 1.f, 1.f,
		0.0f, 0.0f, 0.0f, 0.0f,   1.f, 1.f, 1.f,

		0.0f, size, 0.0f, 1.0f,  1.f, 1.f, 1.f,
		size, size, 1.0f, 1.0f,   1.f, 1.f, 1.f,
		size, 0.0f, 1.0f, 0.0f,  1.f, 1.f, 1.f
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