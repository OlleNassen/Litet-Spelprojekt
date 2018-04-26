#pragma once
#include"GL/glew.h"

#include<glm/gtc/matrix_transform.hpp>
#include<glm/gtc/type_ptr.hpp>

class Shader;
class Texture2D;

class Sprite
{
private:
	glm::vec2 vertex[12];
	
	GLuint quadVAO;
	GLuint VBO;
	Shader *shader;

	Texture2D* texture;
	Texture2D* normalMap;

	glm::vec2 size;
	GLfloat rotation;
	glm::vec3 color;

	glm::mat4 model;

public:
	float posX;
	float posY;

	Sprite(Shader* shader, Texture2D* texture, Texture2D* normalMap = nullptr, const glm::vec2& size = glm::vec2(48, 48));
	~Sprite();
	void draw(const glm::vec2& position, const glm::mat4& view, const glm::mat4& projection);

	void update(const glm::vec2& position);

	void initSprite();

	void setTexture(Texture2D* texture);

	void rotate(float degrees);

	void setTextureRect(int left, int top, int right, int bottom);
};