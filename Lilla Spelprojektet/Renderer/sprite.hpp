#pragma once
#include "../libs.h"
#include "Texture2D.hpp"
#include "Shader.hpp"

class Sprite
{
private:
	GLuint quadVAO;
	Texture2D* texture;
	Shader *shader;
	float x;//Animation
	float y;//Animation
	float width;
	float height;
	glm::vec2 size;
	GLfloat rotate;
	glm::vec3 color;
public:
	Sprite(Texture2D* texture, Shader* shader);
	~Sprite();
	void draw(const glm::vec2& position);

	void initSprite();
	void setTexture(Texture2D* texture);
	void setTexturePosition(float x, float y);
	void setTextureSize(float width, float height);

	
};