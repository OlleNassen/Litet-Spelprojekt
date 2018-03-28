#pragma once

#include<fstream>
#include<iostream>
#include<string>
#include"GL\glew.h"
#include"SFML\OpenGL.hpp"

class Shader
{
private:
	GLuint id;

	std::string load_from_file(const std::string fileName)
	{
		std::ifstream in_file(fileName.c_str());
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
			throw("SHADER::LOAD_FROM_FILE::COULD_NOT_OPEN_FILE");

		in_file.close();

		return file;
	}
	
	GLuint create_shader(const std::string fileName, GLenum type)
	{
		int success;
		char infoLog[512];

		GLuint shader = glCreateShader(type);

		std::string src_str = this->load_from_file(fileName);
		const GLchar* src = src_str.c_str();

		glShaderSource(shader, 1, &src, NULL);
		glCompileShader(shader);

		//Error
		glGetShaderiv(shader, GL_COMPILE_STATUS, &success);

		if (!success)
		{
			glGetShaderInfoLog(shader, 512, NULL, infoLog);
			std::cout << infoLog << "\n";
		}
	}

public:
	Shader(const std::string vertexShaderFile, const std::string fragmentShaderFile, const std::string geometryShaderFile = "")
	{
		int success;
		char infoLog[512];

		bool geometry = false;
		if (geometryShaderFile != "")
			geometry = true;

		GLuint vertexShader = this->create_shader(vertexShaderFile, GL_VERTEX_SHADER);
		GLuint fragmentShader = this->create_shader(fragmentShaderFile, GL_FRAGMENT_SHADER);
		GLuint geometryShader = 0;

		if (geometry)
		{
			geometryShader = this->create_shader(geometryShaderFile, GL_GEOMETRY_SHADER);
		}

		this->id = glCreateProgram();
		glAttachShader(this->id, vertexShader);
		glAttachShader(this->id, fragmentShader);
		
		if(geometry)
			glAttachShader(this->id, geometryShader);

		glLinkProgram(this->id);

		//Error
		glGetProgramiv(this->id, GL_LINK_STATUS, &success);

		if (!success)
		{
			glGetProgramInfoLog(this->id, 512, NULL, infoLog);

			std::cout << infoLog << "\n";
		}

		//Cleanup
		glDeleteShader(vertexShader);
		glDeleteShader(fragmentShader);
		glDeleteShader(geometryShader);
	}

	virtual ~Shader()
	{
		glDeleteProgram(this->id);
	}

	//Accessors
	inline const GLuint& getID() const
	{
		return this->id;
	}

};