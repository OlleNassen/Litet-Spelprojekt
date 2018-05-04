#pragma once
#include <GL/glew.h>
#include <glm\glm.hpp>

struct ParticleStruct
{
	glm::vec2 positions[10000]; //Position x,y and timeLeft on Z
	//glm::vec4 color;
};

class ComputeShader
{
public:
	ComputeShader();
	~ComputeShader();

	void load(const char* computeShaderFile);
	ParticleStruct* compute(const glm::vec2& from, const glm::vec2& to);

private:
	unsigned int shaderProgram;
	unsigned int storageBuffer;
	unsigned int sharedBuffer;
};

