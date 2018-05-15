#include "compute_shader.hpp"
#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <GL/glew.h>
#include <glm/glm.hpp>
#include<glm/gtc/type_ptr.hpp>

ComputeShader::ComputeShader()
{
}


ComputeShader::~ComputeShader()
{
}

void ComputeShader::load(const char* computeShaderFile)
{
	/** 1. retrieve the compute source code from filePath */
	std::string computeCode;
	std::ifstream shaderFile;

	/** open files */
	shaderFile.open(computeShaderFile);
	std::stringstream shaderStream;

	/** read file's buffer contents into streams */
	shaderStream << shaderFile.rdbuf();

	/** close file handlers */
	shaderFile.close();

	/** convert stream into string */
	computeCode = shaderStream.str();

	const char* shaderCode = computeCode.c_str();

	/** 2. compile shaders */
	int success;
	char infoLog[512];

	/** compute shader */
	unsigned int compute = glCreateShader(GL_COMPUTE_SHADER);
	glShaderSource(compute, 1, &shaderCode, NULL);
	glCompileShader(compute);

	/** print compile errors if any */
	glGetShaderiv(compute, GL_COMPILE_STATUS, &success);
	if (!success)
	{
		glGetShaderInfoLog(compute, 512, NULL, infoLog);
		std::cout << "ERROR::SHADER::COMPUTE::COMPILATION_FAILED\n" << infoLog << std::endl;
	}

	/** shader Program */
	shaderProgram = glCreateProgram();
	glAttachShader(shaderProgram, compute);
	glLinkProgram(shaderProgram);

	/** print linking errors if any */
	glGetProgramiv(shaderProgram, GL_LINK_STATUS, &success);
	if (!success)
	{
		glGetProgramInfoLog(shaderProgram, 512, NULL, infoLog);
		std::cout << "ERROR::SHADER::PROGRAM::LINKING_FAILED\n" << infoLog << std::endl;
	}

	/** delete the shaders as they're linked into our program now and no longer necessery */
	glDeleteShader(compute);

	/** Storage buffer */
	glUseProgram(shaderProgram);
	glGenBuffers(1, &storageBuffer);
	glBindBuffer(GL_SHADER_STORAGE_BUFFER, storageBuffer);
	glBufferData(GL_SHADER_STORAGE_BUFFER, sizeof(ParticleStruct), &data, GL_STATIC_COPY);
	static int index = 0;
	glBindBufferBase(GL_SHADER_STORAGE_BUFFER, index++, storageBuffer);
	glBindBuffer(GL_SHADER_STORAGE_BUFFER, 0);
}

ParticleStruct* ComputeShader::compute(const glm::vec2& from, const glm::vec2& to)
{
	ParticleStruct* result = nullptr;
	glm::vec2 to_from = glm::vec2(to - from);

	if (shaderProgram)
	{
		glUseProgram(shaderProgram);
		glUniform2fv(glGetUniformLocation(shaderProgram, "to_from"), 1, glm::value_ptr(to_from));

		glUniform2fv(glGetUniformLocation(shaderProgram, "from"), 1, glm::value_ptr(from));
		glUniform2fv(glGetUniformLocation(shaderProgram, "to"), 1, glm::value_ptr(to));


		glBindBuffer(GL_SHADER_STORAGE_BUFFER, storageBuffer);
		glDispatchCompute(10, 10, 1);
		
		glUnmapBuffer(GL_SHADER_STORAGE_BUFFER);
		result = (ParticleStruct*)glMapBuffer(GL_SHADER_STORAGE_BUFFER, GL_READ_ONLY);
		glBindBuffer(GL_SHADER_STORAGE_BUFFER, 0);
		glUseProgram(0);
	}
	
	return result;
	
}

ParticleStruct * ComputeShader::pixie(const glm::vec2& pixiePos)
{
	ParticleStruct* result = nullptr;

	if (shaderProgram)
	{
		glUseProgram(shaderProgram);

		glUniform2fv(glGetUniformLocation(shaderProgram, "pixie"), 1, glm::value_ptr(pixiePos));

		glBindBuffer(GL_SHADER_STORAGE_BUFFER, storageBuffer);

		/*
		glDispatchCompute(10, 10, 1);
		*/

		glUnmapBuffer(GL_SHADER_STORAGE_BUFFER);
		result = (ParticleStruct*)glMapBuffer(GL_SHADER_STORAGE_BUFFER, GL_READ_ONLY);
		glBindBuffer(GL_SHADER_STORAGE_BUFFER, 0);
		glUseProgram(0);

	}

	return result;
}