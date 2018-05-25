#pragma once
#include "../GameEngine/compute_shader.hpp"
#include "shader.hpp"
#include "texture_2d.hpp"

#define NUM_BILLBOARDS 1000

class Billboard
{
private:
	Shader* shader;
	Texture2D* texture;

	glm::mat4 model;

	GLuint VAO;
	GLuint VBO;
	GLuint instanceVBO;

	glm::vec2 positions[NUM_BILLBOARDS];
	glm::vec4 color;

public:
	Billboard(Shader* shader, Texture2D* texture);
	~Billboard();

	void render(const glm::mat4& view, const glm::mat4& projection);
	void update(float deltaTime);
	void setColor(const glm::vec4& color);

private:
	void initBillboards();
};