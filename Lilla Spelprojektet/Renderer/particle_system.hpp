#pragma once
#include "GL\glew.h"
#include "glm\glm.hpp"
#include <queue>
#include "Shader.hpp"
#include "texture_2d.hpp"

#define maxNumParticles 5000

struct Particles
{
	std::vector<glm::vec2> translations;
	std::vector<float> timeLeft;
	//std::vector<glm::vec2> velocity;
	//std::vector<glm::vec3> colors;


	glm::vec2 globalVelocity;
	//float globalVelocity = 10.f;
	float globalTimeLeft = 10.f;
	float globalSpeed;
	glm::vec3 color;
	
	int numParticles = 0;
	
	
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

	glm::mat4 model;

public:
	ParticleSystem(Shader* shader, Texture2D* diffuse, Texture2D* normalMap = nullptr);
	~ParticleSystem();

	void render(const glm::mat4& view, const glm::mat4& projection);
	void update(float dt);

	void push(unsigned int amount, float x, float y);
private:
	void removeParticles();
	void initParticleSystem();
};