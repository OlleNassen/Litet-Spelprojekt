#pragma once
#include "../libs.h"
#include "Texture2D.hpp"
#include "Shader.hpp"

class Sprite
{
private:
	GLuint quadVAO;
	Shader *shader;

	Texture2D* texture;
	Texture2D* normalMap;

	float x;//Animation
	float y;//Animation
	float width;
	float height;
	glm::vec2 size;
	GLfloat rotate;
	glm::vec3 color;
public:
	float posX;
	float posY;

	Sprite(Shader* shader, Texture2D* texture, Texture2D* normalMap = nullptr);
	~Sprite();
	void draw(const glm::vec2& position, const glm::mat4& view, const glm::mat4& projection);

	void initNormalSprite();
	void initSprite();

	void setTexture(Texture2D* texture);
	void setTexturePosition(float x, float y);
	void setTextureSize(float width, float height);

	
};