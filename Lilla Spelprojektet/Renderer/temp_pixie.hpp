#pragma once
#include <GL\glew.h>
#include "Shader.hpp"
#include "texture_2d.hpp"
#include "../GameEngine/compute_shader.hpp"

#define MAX_NUM_PARTICLES 10000

class PixieParticles
{
private:
	//ComputeShader compShader;
	Shader* shader;
	Texture2D* texture;

	GLuint VAO;
	GLuint VBO;
	GLuint instanceVBO;

	glm::mat4 model;

	ParticleStruct* particleStruct = nullptr;

	glm::vec2 offsets[MAX_NUM_PARTICLES];

public:
	PixieParticles(Shader* shader, Texture2D* texture);
	~PixieParticles();

	void render(const glm::mat4& view, const glm::mat4& projection);
	void update(const glm::vec2& pixiePos);

private:
	void initPixie();
};