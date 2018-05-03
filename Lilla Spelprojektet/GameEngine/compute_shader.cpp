#include "compute_shader.hpp"
#include <iostream>
#include <fstream>
#include <sstream>



ComputeShader::ComputeShader()
{
}


ComputeShader::~ComputeShader()
{
}

void ComputeShader::load(const GLchar* computeShaderFile)
{
	int success;
	char infoLog[512];

	std::string s = this->load_from_file(computeShaderFile);
	const GLchar* src = s.c_str();

	unsigned int computeShader = glCreateShader(GL_COMPUTE_SHADER);

	glShaderSource(computeShader, 1, &src, nullptr);
	glCompileShader(computeShader);

	//glDispatchComputeGroupSize(num_groups_x, num_groups_y, num_groups_z,work_group_size_x,work_group_size_y,work_group_size_z);

	//Error
	glGetShaderiv(computeShader, GL_COMPILE_STATUS, &success);

	if (!success)
	{
		glGetShaderInfoLog(computeShader, 512, nullptr, infoLog);
		std::cout << infoLog << "\n";
	}

	this->id = glCreateProgram();
	glAttachShader(this->id, computeShader);

	glLinkProgram(this->id);

	//Error
	glGetProgramiv(this->id, GL_LINK_STATUS, &success);

	if (!success)
	{
		glGetProgramInfoLog(this->id, 512, nullptr, infoLog);

		std::cout << infoLog << "\n";
	}

	//Cleanup
	glDeleteShader(computeShader);
}

std::string ComputeShader::load_from_file(const GLchar* fileName)
{
	std::ifstream in_file(fileName);
	std::string line = "";
	std::string file = "";

	if (in_file.is_open())
	{
		while (std::getline(in_file, line))
		{
			file += line + "\n";
		}
	}
	else
	{
		std::cout << "SHADER::LOAD_FROM_FILE::COULD_NOT_OPEN_FILE" << fileName << "\n";
		throw("SHADER::LOAD_FROM_FILE::COULD_NOT_OPEN_FILE");
	}

	in_file.close();

	return file;
}