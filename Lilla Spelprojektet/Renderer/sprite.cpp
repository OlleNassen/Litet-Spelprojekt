#include "sprite.hpp"
#include "texture_2d.hpp"
#include "shader.hpp"
#define BUFFER_OFFSET(i) ((char *)nullptr + (i))

Sprite::Sprite(Shader* shader, Texture2D* texture, Texture2D* normalMap, const glm::vec2& size)
	:normalMap(nullptr) // Needed for some reason
{
	posX = 0.0f;
	posY = 0.0f;

	this->texture = texture;
	this->shader = shader;

	this->normalMap = normalMap;

	initSprite();

	this->size.x = size.x;
	this->size.y = size.y;
	rotation = 0.f;
	color = glm::vec3(0, 1, 0);
	model = glm::mat4(1.f);
}

Sprite::~Sprite()
{
}

void Sprite::initSprite()
{
	// Configure VAO/VBO
	GLuint VBO;
	//Fix this ugly mess
	float vertices[] = {
		// Pos and texture coordinates
		0.0f, 1.0f, 0.0f, 1.0f,
		1.0f, 0.0, 1.0f, 0.0f,
		0.0f, 0.0f, 0.0f, 0.0f,

		0.0f, 1.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,
		1.0f, 0.0f, 1.0f, 0.0f
	};

	glGenVertexArrays(1, &this->quadVAO);
	glBindVertexArray(this->quadVAO);

	glGenBuffers(1, &VBO);
	glBindBuffer(GL_ARRAY_BUFFER, VBO);
	glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);


	// Buffer offset. 
	int offset = 0;

	//Position
	glEnableVertexAttribArray(0);
	glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 4 * sizeof(float), BUFFER_OFFSET(offset));
	offset += sizeof(float) * 2;
	//Texture coordinates
	glEnableVertexAttribArray(1);
	glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 4 * sizeof(float), BUFFER_OFFSET(offset));
	offset += sizeof(float) * 2;
}

void Sprite::draw(const glm::vec2& position, const glm::mat4& view, const glm::mat4& projection)
{
	update(position);

	if (this->normalMap == nullptr)
	{
		this->shader->setInt(0, "image");
	}
	else
	{
		shader->setInt(0, "diffuseMap");
		shader->setInt(1, "normalMap");
	}
	static int test = 0;
	this->shader->setMatrix4fv(model, "model");
	this->shader->setMatrix4fv(view, "view");
	this->shader->setMatrix4fv(projection, "projection");

	this->shader->use();

	if (this->normalMap == nullptr)
	{
		texture->bind(0);

	}
	else //Fix texture class and avoid this
	{
		texture->bind(0);
		normalMap->bind(1);
	}

	glBindVertexArray(this->quadVAO);
	glDrawArrays(GL_TRIANGLES, 0, 6);
	glBindVertexArray(0);
}

void Sprite::update(const glm::vec2& position)
{
	// Prepare transformations
	model = glm::mat4(1.f);
	model = glm::translate(model, glm::vec3(position, 0.0f));

	model = glm::translate(model, glm::vec3(0.5f * size.x, 0.5f * size.y, 0.0f));
	model = glm::rotate(model, rotation, glm::vec3(0.0f, 0.f, 0.1f));
	model = glm::translate(model, glm::vec3(-0.5f * size.x, -0.5f * size.y, 0.0f));

	model = glm::scale(model, glm::vec3(size, 1.0f));
}

void Sprite::setTexture(Texture2D * texture)
{
	this->texture = texture;
}

void Sprite::rotate(float degrees)
{
	this->rotation = degrees;
}

