#pragma once
#include"Shader.hpp"
#include "Texture2D.hpp"
//Todo: Implement shader class before using this


class SpriteRenderer
{
public:
	SpriteRenderer(Shader &shader);
	~SpriteRenderer();

	void DrawSprite(glm::vec2 position,
		glm::vec2 size = glm::vec2(10, 10), GLfloat rotate = 0.0f,
		glm::vec3 color = glm::vec3(1.0f));

	void DrawSprite(Texture2D &texture, glm::vec2 position,
		glm::vec2 size = glm::vec2(10, 10), GLfloat rotate = 0.0f,
		glm::vec3 color = glm::vec3(1.0f));

private:
	Shader *shader;
	GLuint quadVAO;

	void initRenderData();

	void DrawSprite(Texture2D &texture, glm::vec2 position,
		glm::vec2 size, GLfloat rotate, glm::vec3 color);
};

