#pragma once
#include "GL\glew.h"
#include "glm\glm.hpp"
#include "Shader.hpp"
#include "texture_2d.hpp"

#define maxNumParticles 100

struct Particles
{
	glm::vec2 translations[maxNumParticles];
	float timeLeft[maxNumParticles];
	bool exists[maxNumParticles];
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
	Shader * shader;
	Texture2D* texture;
	Texture2D* normalMap;

	GLuint VAO;
	GLuint VBO;

	GLuint instanceVBO;

	Particles particles;

	glm::mat4 model;

public:
	ParticleEmitter(Shader* shader, Texture2D* diffuse, Texture2D* normalMap = nullptr);
	~ParticleEmitter();

	void render(const glm::mat4& view, const glm::mat4& projection);
	void update(float dt, const glm::vec2& position);

	void push(unsigned int amount, float x, float y);
private:
	void removeParticles();
	void initParticleEmitter();
};