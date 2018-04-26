#pragma once
#include "GL\glew.h"
#include "glm\glm.hpp"
#include <queue>
#include "Shader.hpp"

struct Particles
{
	std::queue<glm::vec2> positions;
	std::queue<glm::vec2> direction;
	std::queue<glm::vec3> colors;
	std::queue<float> timeLeft;

	float globalSpeed;

};

class ParticleSystem
{
private:
	Shader * shader;
	glm::vec2 translations[100];

	GLuint VAO;
	GLuint VBO;

	Particles particles;


public:
	ParticleSystem(Shader* shader);
	~ParticleSystem();

	void render();
	void update();
private:
	void initParticleSystem();
};