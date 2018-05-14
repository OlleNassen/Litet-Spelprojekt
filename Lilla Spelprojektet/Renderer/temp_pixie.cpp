#include "temp_pixie.hpp"
#define BUFFER_OFFSET(i) ((char *)nullptr + (i))


PixieParticles::PixieParticles(Shader* shader, Texture2D* texture)
{
	this->shader = shader;
	this->texture = texture;
	compShader.load("Resources/Shaders/pixie.comp");

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

	this->shader->use();

	glBindVertexArray(VAO);

	glBindBuffer(GL_ARRAY_BUFFER, instanceVBO);
	glBufferData(GL_ARRAY_BUFFER, MAX_NUM_PARTICLES * sizeof(glm::vec2), &positions[0], GL_STATIC_DRAW);

	glDrawArraysInstanced(GL_TRIANGLES, 0, 6, MAX_NUM_PARTICLES);
	glBindVertexArray(0);
}

void PixieParticles::update(const glm::vec2& pixiePos)
{
	model = glm::mat4(1.f);
	model = glm::translate(model, glm::vec3(pixiePos, 0.0f));

	model = glm::translate(model, glm::vec3(0.5f * 48.f, 0.5f * 48.f, 0.0f));
	model = glm::rotate(model, 0.f, glm::vec3(0.0f, 0.f, 0.1f));
	model = glm::translate(model, glm::vec3(-0.5f * 48.f, -0.5f * 48.f, 0.0f));

	model = glm::scale(model, glm::vec3(256.f, 256.f, 1.0f));

	particleStruct = compShader.pixie(pixiePos);
}

void PixieParticles::initPixie()
{
	glGenBuffers(1, &instanceVBO);
	glBindBuffer(GL_ARRAY_BUFFER, instanceVBO);
	glBufferData(GL_ARRAY_BUFFER, sizeof(glm::vec2) * MAX_NUM_PARTICLES, &positions[0], GL_STATIC_DRAW);
	glBindBuffer(GL_ARRAY_BUFFER, 0);

	float quadVertices[] = {
		// positions     // colors
		0.0f, 0.01f, 0.0f, 1.0f,  1.f, 1.f, 1.f,
		0.005f, 0.0f, 1.0f, 0.0f,    1.f, 1.f, 1.f,
		0.0f, 0.0f, 0.0f, 0.0f,   1.f, 1.f, 1.f,

		0.0f, 0.01f, 0.0f, 1.0f,  1.f, 1.f, 1.f,
		0.005f, 0.01f, 1.0f, 1.0f,   1.f, 1.f, 1.f,
		0.005f, 0.0f, 1.0f, 0.0f,  1.f, 1.f, 1.f
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
