#pragma once
#include"Shader.hpp"
#include "Texture2D.hpp"

class SpriteRenderer
{
public:
	SpriteRenderer(Shader *shader);
	~SpriteRenderer();
	void drawSprite(Texture2D &texture, glm::vec2 position,
		glm::vec2 size, GLfloat rotate, glm::vec3 color);

private:
	Shader *shader;
	GLuint quadVAO;
	void initRenderData();
};

