#include "billboard.hpp"

#define BUFFER_OFFSET(i) ((char *)nullptr + (i))
#include <ctime>


Billboard::Billboard(Shader* shader, Texture2D* texture)
{
	this->shader = shader;
	this->texture = texture;

	initBillboards();

	srand(time(NULL));

	int index = 0;
	float offset = 0.1f;
	for (int y = -10; y < 10; y += 2)
	{
		for (int x = -10; x < 10; x += 2)
		{
			glm::vec2 translation;
			translation.x = (float)x / 10.0f + offset;
			translation.y = (float)y / 10.0f + offset;
			positions[index++] = translation;
		}
	}
}

Billboard::~Billboard()
{
}

void Billboard::render(const glm::mat4& projection)
{
	this->shader->setMatrix4fv(model, "model");
	this->shader->setMatrix4fv(projection, "projection");

	//shader->setInt(0, "image");

	//this->texture->bind(0);

	this->shader->use();

	glBindVertexArray(this->VAO);

	glBindBuffer(GL_ARRAY_BUFFER, instanceVBO);
	glBufferData(GL_ARRAY_BUFFER, NUM_BILLBOARDS * sizeof(glm::vec2), &positions[0], GL_STATIC_DRAW);

	glDrawArraysInstanced(GL_TRIANGLES, 0, 6, NUM_BILLBOARDS); // 100 triangles of 6 vertices each
	glBindVertexArray(0);
}

void Billboard::update(const glm::vec2& camPos)
{

	model = glm::mat4(1.f);
	model = glm::translate(model, glm::vec3(glm::vec2(0,0), 0.0f));

	for (int i = 0; i < NUM_BILLBOARDS; i++)
	{
		if (positions[i].y < -1.f)
		{
			positions[i].y = 1;
			positions[i].x = ((rand() % 2000) / 1000.0f) - 1;
		}
		positions[i].y -= 0.001;
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
		-0.05f,  0.05f,  1.0f, 0.0f, 0.0f,
		0.05f, -0.05f,  0.0f, 1.0f, 0.0f,
		-0.05f, -0.05f,  0.0f, 0.0f, 1.0f,

		-0.05f,  0.05f,  1.0f, 0.0f, 0.0f,
		0.05f, -0.05f,  0.0f, 1.0f, 0.0f,
		0.05f,  0.05f,  0.0f, 1.0f, 1.0f
	};

	glGenVertexArrays(1, &VAO);
	glGenBuffers(1, &VBO);
	glBindVertexArray(VAO);
	glBindBuffer(GL_ARRAY_BUFFER, VBO);
	glBufferData(GL_ARRAY_BUFFER, sizeof(quadVertices), quadVertices, GL_STATIC_DRAW);
	glEnableVertexAttribArray(0);
	glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)0);
	glEnableVertexAttribArray(1);
	glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)(2 * sizeof(float)));
	// also set instance data
	glEnableVertexAttribArray(2);
	glBindBuffer(GL_ARRAY_BUFFER, instanceVBO); // this attribute comes from a different vertex buffer
	glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, 2 * sizeof(float), (void*)0);
	glBindBuffer(GL_ARRAY_BUFFER, 0);
	glVertexAttribDivisor(2, 1); // tell OpenGL this is an instanced vertex attribute.

}
