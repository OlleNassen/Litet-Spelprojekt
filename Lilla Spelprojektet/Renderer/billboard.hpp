#pragma once
#include "../GameEngine/compute_shader.hpp"
#include "shader.hpp"

#define MAX_NUM_PARTICLES 10000

class Billboard
{
private:
	ComputeShader computeShader;
	Shader* shader;

	glm::mat4 model;

	GLuint VAO;
	GLuint VBO;

	GLuint instanceVBO;

public:
	Billboard(Shader* shader);
	~Billboard();

	void render();
	void update();

private:
	void initBillboards();
};