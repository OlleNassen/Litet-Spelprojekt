#include "billboard.hpp"

#define BUFFER_OFFSET(i) ((char *)nullptr + (i))
#include <ctime>


Billboard::Billboard(Shader* shader, Texture2D* texture)
{
	this->shader = shader;
	this->texture = texture;

	initBillboards();

	srand(time(NULL));

	for (int i = 0; i < NUM_BILLBOARDS; i++)
	{
		positions[i].y = ((rand() % 2000) / 1000.0f) - 1;
		positions[i].x = ((rand() % 2000) / 1000.0f) - 1;
	}

}

Billboard::~Billboard()
{
}

void Billboard::render()
{

	shader->setInt(0, "image");

	this->texture->bind(0);

	this->shader->use();

	glBindVertexArray(this->VAO);

	glBindBuffer(GL_ARRAY_BUFFER, instanceVBO);
	glBufferData(GL_ARRAY_BUFFER, NUM_BILLBOARDS * sizeof(glm::vec2), &positions[0], GL_STATIC_DRAW);

	glDrawArraysInstanced(GL_TRIANGLES, 0, 6, NUM_BILLBOARDS); // 100 triangles of 6 vertices each
	glBindVertexArray(0);
}

void Billboard::update(float delta)
{

	for (int i = 0; i < NUM_BILLBOARDS; i++)
	{
		if (positions[i].y < -1.f)
		{
			positions[i].y = 1;
			positions[i].x = ((rand() % 2000) / 1000.0f) - 1;
		}
		static float speed = 14;
		positions[i].y -= speed * delta;
	}
}

void Billboard::initBillboards()
{
	glGenBuffers(1, &instanceVBO);
	glBindBuffer(GL_ARRAY_BUFFER, instanceVBO);
	glBufferData(GL_ARRAY_BUFFER, sizeof(glm::vec2) * NUM_BILLBOARDS, &positions[0], GL_STATIC_DRAW);
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
