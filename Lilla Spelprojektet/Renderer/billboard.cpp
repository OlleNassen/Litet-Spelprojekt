#include "billboard.hpp"

#define BUFFER_OFFSET(i) ((char *)nullptr + (i))
#include <ctime>


Billboard::Billboard(Shader* shader, Texture2D* texture)
{
	this->shader = shader;
	this->texture = texture;
	srand(time(NULL));

	/*
	for (int i = 0; i < NUM_BILLBOARDS; i++)
	{
		positions[i].y = ((rand() % 2000) / 1000.0f) - 1;
		positions[i].x = ((rand() % 2000) / 1000.0f) - 1;
	}
	*/

	for (int i = 0; i < NUM_BILLBOARDS; i++)
	{
		positions[i].x = rand() % 3000;
		positions[i].y = rand() % 2000;
	}

	initBillboards();


}

Billboard::~Billboard()
{
}

void Billboard::render(const glm::mat4& view, const glm::mat4& projection)
{
	this->shader->use();

	this->shader->setMatrix4fv(model, "model");
	this->shader->setMatrix4fv(view, "view");
	this->shader->setMatrix4fv(projection, "projection");
	this->shader->setInt(0, "image");

	this->texture->bind(0);

	glBindVertexArray(this->VAO);
	glDrawArraysInstanced(GL_TRIANGLES, 0, 6, NUM_BILLBOARDS); // 100 triangles of 6 vertices each
	glBindVertexArray(0);

	shader->unuse();
}

void Billboard::update(float deltaTime)
{
	model = glm::mat4(1.f);
	model = glm::translate(model, glm::vec3(0,0, 0.0f));
	
	float speed = 650;
	for (int i = 0; i < NUM_BILLBOARDS; i++)
	{
		if (positions[i].y > 2000.f)
		{
			positions[i].x = rand() % 3000;
			positions[i].y = -5;
		}
		positions[i].y += speed * deltaTime;
	}

	glBindBuffer(GL_ARRAY_BUFFER, instanceVBO);
	glBufferData(GL_ARRAY_BUFFER, NUM_BILLBOARDS * sizeof(glm::vec2), &positions[0], GL_STATIC_DRAW);
}

void Billboard::initBillboards()
{
	glGenBuffers(1, &instanceVBO);
	glBindBuffer(GL_ARRAY_BUFFER, instanceVBO);
	glBufferData(GL_ARRAY_BUFFER, sizeof(glm::vec2) * NUM_BILLBOARDS, &positions[0], GL_STATIC_DRAW);
	glBindBuffer(GL_ARRAY_BUFFER, 0);

	glm::vec2 size = glm::vec2(3.f, 9.f);

	float quadVertices[] = {
		// positions     // colors
		0.0f, size.y, 0.0f, 1.0f,  1.f, 1.f, 1.f,
		size.x, 0.0f, 1.0f, 0.0f,    1.f, 1.f, 1.f,
		0.0f, 0.0f, 0.0f, 0.0f,   1.f, 1.f, 1.f,

		0.0f, size.y, 0.0f, 1.0f,  1.f, 1.f, 1.f,
		size.x, size.y, 1.0f, 1.0f,   1.f, 1.f, 1.f,
		size.x, 0.0f, 1.0f, 0.0f,  1.f, 1.f, 1.f
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
