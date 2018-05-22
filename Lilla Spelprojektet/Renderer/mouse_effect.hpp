#pragma once
#include <GL\glew.h>
#include "shader.hpp"
#include "texture_2d.hpp"
#include "sprite.hpp"

class MouseEffect
{
private:
	Shader* shader;
	Texture2D* texture;

	GLuint VAO;
	GLuint VBO;
	GLuint instanceVBO;

	glm::mat4 model;

public:
	MouseEffect(Shader* shader, Texture2D* texture);
	~MouseEffect();
	void render(const glm::mat4& view, const glm::mat4& projection);
	void update(const glm::vec2& pixiePos, float deltaTime);

private:
	void initMouseEffect();
};