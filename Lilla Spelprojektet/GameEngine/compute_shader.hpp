#pragma once
#include <GL/glew.h>

class ComputeShader
{
public:
	ComputeShader();
	~ComputeShader();

	void load(const char* computeShaderFile);

private:
	unsigned int shaderProgram;
	unsigned int storageBuffer;
};

