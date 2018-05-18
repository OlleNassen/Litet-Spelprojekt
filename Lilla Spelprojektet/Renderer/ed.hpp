#pragma once
#include <GL\glew.h>
#include "shader.hpp"
#include "texture_2d.hpp"
#include "sprite.hpp"

class Ed
{
private:
	Shader * shader;
	Texture2D* texture;

	GLuint VAO;
	GLuint VBO;
	GLuint instanceVBO;

	glm::mat4 model;

public:
	Ed(Shader* shader, Texture2D* texture);
	~Ed();
	void render(const glm::mat4& view, const glm::mat4& projection);
	void update(const glm::vec2& pixiePos);

private:
	void initEd();
};