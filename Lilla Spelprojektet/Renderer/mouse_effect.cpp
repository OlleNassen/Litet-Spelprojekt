#include "mouse_effect.hpp"
#define BUFFER_OFFSET(i) ((char *)nullptr + (i))

MouseEffect::MouseEffect(Shader* shader, Texture2D* texture)
{
	this->shader = shader;
	this->texture = texture;
	initMouseEffect();
}

MouseEffect::~MouseEffect()
{

}

void MouseEffect::render(const glm::mat4& view, const glm::mat4& projection)
{
	this->shader->setMatrix4fv(model, "model");
	this->shader->setMatrix4fv(view, "view");
	this->shader->setMatrix4fv(projection, "projection");

	this->texture->bind(0);

	this->shader->use();

	glBindVertexArray(this->VAO);
	glDrawArrays(GL_TRIANGLES, 0, 6);
	glBindVertexArray(0);

	this->shader->unuse();
}

void MouseEffect::update(const glm::vec2& pixiePos)
{
	shader->use();
	static float temp = 0.0;
	shader->setFloat(temp += 0.016f, "u_time");
	shader->unuse();

	model = glm::mat4(1.f);
	model = glm::translate(model, glm::vec3(pixiePos - glm::vec2(120, 120) + glm::vec2(60, 45), 0.0f));
}

void MouseEffect::initMouseEffect()
{
	const float size = 240.f;
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
}