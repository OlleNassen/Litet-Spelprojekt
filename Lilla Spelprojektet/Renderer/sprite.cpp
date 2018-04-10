#include "sprite.hpp"
#define BUFFER_OFFSET(i) ((char *)nullptr + (i))

Sprite::Sprite(Texture2D * texture, Shader* shader)
{
	width = 1.f;
	height = 1.f;
	x = 0.f;
	y = 0.f;
	this->texture = texture;
	this->shader = shader;
	initSprite();

	size.x = 48.f;
	size.y = 48.f;
	rotate = 0.f;
	color = glm::vec3(0, 1, 0);
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
		// Pos              //Normal     // Tex      // COlor
		0.0f, 1.0f, 0.0f, 1.0f, x, height, 0.0f, 1.0f, 0.0f,
		1.0f, 0.0, 0.0f, 1.0f, height, y, 0.0f, 1.0f, 0.0f,
		0.0f, 0.0f, 0.0f, 1.0f, x, y, 0.0f, 1.0f, 0.0f,

		0.0f, 1.0f, 0.0f, 1.0f, x, height, 0.0f, 1.0f, 0.0f,
		1.0f, 1.0f, 0.0f, 1.0f, width, height, 0.0f, 1.0f, 0.0f,
		1.0f, 0.0f, 0.0f, 1.0f, width, y, 0.0f, 1.0f, 0.0f
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
	glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 9 * sizeof(float), BUFFER_OFFSET(offset));
	offset += sizeof(float) * 2;
	//Normal
	glEnableVertexAttribArray(1);
	glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 9 * sizeof(float), BUFFER_OFFSET(offset));
	offset += sizeof(float) * 2;
	//Texture coordinates
	glEnableVertexAttribArray(2);
	glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, 9 * sizeof(float), BUFFER_OFFSET(offset));
	offset += sizeof(float) * 2;
	//Color
	glEnableVertexAttribArray(3);
	glVertexAttribPointer(3, 3, GL_FLOAT, GL_FALSE, 9 * sizeof(float), BUFFER_OFFSET(offset));
	offset += sizeof(float) * 3;
}
//Player draw
void Sprite::drawPlayer(lua_State* luaState)
{
	// Prepare transformations
	glm::mat4 model = glm::mat4(1.f);
	model = glm::translate(model, glm::vec3(getPlayerPosition(luaState), 0.0f));

	model = glm::translate(model, glm::vec3(0.5f * size.x, 0.5f * size.y, 0.0f));
	model = glm::rotate(model, rotate, glm::vec3(0.0f, 0.0f, 1.0f));
	model = glm::translate(model, glm::vec3(-0.5f * size.x, -0.5f * size.y, 0.0f));

	model = glm::scale(model, glm::vec3(size, 1.0f));

	this->shader->setMatrix4fv(model, "model");
	this->shader->use();
	texture->bind();

	glBindVertexArray(this->quadVAO);
	glDrawArrays(GL_TRIANGLES, 0, 6);
	glBindVertexArray(0);
}

void Sprite::drawTile(const glm::vec2& position)
{
	// Prepare transformations
	glm::mat4 model = glm::mat4(1.f);
	model = glm::translate(model, glm::vec3(position, 0.0f));

	model = glm::translate(model, glm::vec3(0.5f * 48.f, 0.5f * 48.f, 0.0f));
	model = glm::rotate(model, 0.f, glm::vec3(0.0f, 0.0f, 1.0f));
	model = glm::translate(model, glm::vec3(-0.5f * 48.f, -0.5f * 48.f, 0.0f));

	model = glm::scale(model, glm::vec3(glm::vec2(48.f), 1.0f));


	this->shader->setMatrix4fv(model, "model");
	this->shader->use();
	texture->bind();

	glBindVertexArray(this->quadVAO);
	glDrawArrays(GL_TRIANGLES, 0, 6);
	glBindVertexArray(0);
}

void Sprite::setTexture(Texture2D * texture)
{
	this->texture = texture;
}

void Sprite::setTexturePosition(float x, float y)
{
	this->x = x;
	this->y = y;
}

void Sprite::setTextureSize(float width, float height)
{
	this->width = width;
	this->height = height;
}

glm::vec2 Sprite::getPlayerPosition(lua_State* luaState) const
{
	glm::vec2 position;
	lua_getglobal(luaState, "getPosition");
	if (lua_isfunction(luaState, -1))
	{
		lua_pcall(luaState, 0, 2, 0);
		position.x = lua_tonumber(luaState, -1);
		position.y = lua_tonumber(luaState, -2);
		lua_pop(luaState, 2);
	}
	else std::cout << "getPosition is not a function" << std::endl;

	return position;
}
