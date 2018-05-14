#pragma once
#include "../GameEngine/compute_shader.hpp"
#include "shader.hpp"
#include "texture_2d.hpp"

#define NUM_BILLBOARDS 100

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


public:
	Billboard(Shader* shader, Texture2D* texture);
	~Billboard();

	void render();
	void update(float deltas);

private:
	void initBillboards();
};