#pragma once
#include <GL/glew.h>
#include <string>
class ComputeShader
{
public:
	ComputeShader();
	~ComputeShader();

	void load(const GLchar* computeShaderFile);
	std::string load_from_file(const GLchar* fileName);

private:
	unsigned int id;
};

