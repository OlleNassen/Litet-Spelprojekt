#pragma once
#include "GL\glew.h"
#include "glm\glm.hpp"
#include <queue>
#include "Shader.hpp"
#include "texture_2d.hpp"

struct Particles
{
	std::vector<glm::vec2> positions;
	std::vector<glm::vec2> velocity;
	std::vector<glm::vec3> colors;

	std::vector<glm::vec2> translations;

	std::vector<float> timeLeft;

	float globalSpeed;

};

class ParticleSystem
{
private:
	Shader * shader;
	Texture2D* texture;
	Texture2D* normalMap;

	GLuint VAO;
	GLuint VBO;

	GLuint instanceVBO;

	Particles particles;


public:
	ParticleSystem(Shader* shader, Texture2D* diffuse, Texture2D* normalMap = nullptr);
	~ParticleSystem();

	void render();
	void update();
private:
	void initParticleSystem();
};