#pragma once
#include "GL\glew.h"
#include "glm\glm.hpp"
#include "Shader.hpp"
#include "texture_2d.hpp"
#include "../GameEngine/compute_shader.hpp"

#define MAX_NUM_PARTICLES 10000

struct Particles
{
	glm::vec2 translations[MAX_NUM_PARTICLES];
	float timeLeft[MAX_NUM_PARTICLES];
	bool exists[MAX_NUM_PARTICLES];
	//std::vector<glm::vec2> velocity;
	//std::vector<glm::vec3> colors;

	int first = 0;
	int last = 1;

	glm::vec2 globalVelocity;
	//float globalVelocity = 10.f;
	float globalTimeLeft = 10.f;
	float globalSpeed;
	glm::vec3 color;

	
	
};

class ParticleEmitter
{
private:
	Texture2D* texture;
	Texture2D* normalMap;

	GLuint VAO;
	GLuint VBO;

	GLuint instanceVBO;

	ParticleStruct* particleStruct;

	glm::mat4 model;

	glm::vec2 translations[MAX_NUM_PARTICLES];

public:
	//Temp, put it above
	Particles particles;
	Shader* shader;

	ComputeShader computeShader;

	ParticleEmitter(Shader* shader, Texture2D* diffuse, Texture2D* normalMap = nullptr);
	~ParticleEmitter();

	void render(const glm::mat4& view, const glm::mat4& projection);
	void update(float dt, const glm::vec2& position);

	void updateLaser(float dt, const glm::vec2& position, const glm::vec2 pixiePos);

	void push(unsigned int amount, float x, float y);
private:
	void removeParticles();
	void initParticleEmitter();
};