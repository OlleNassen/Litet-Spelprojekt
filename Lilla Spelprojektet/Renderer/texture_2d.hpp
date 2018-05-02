#pragma once

#include<iostream>
#include<string>

#include"GL/glew.h"
#include"SOIL2.h"

class Texture2D
{
private:
	GLuint texture;
	

public:
	int width;
	int height;
	
	Texture2D()
	{
		this->texture = 0;
	}

	~Texture2D()
	{
		glDeleteTextures(1, &this->texture);
	}

	//Accessors
	inline GLuint getTexture() 
	{
		return this->texture;
	}

	//Functions
	bool loadFromFile(const char* fileName)
	{
		if (this->texture) //Already exists
		{
			glDeleteTextures(1, &this->texture);
			this->texture = 0;
		}

		//load image
		unsigned char* image = SOIL_load_image(fileName, &width, &height, NULL, SOIL_LOAD_RGBA);

		GLenum target = GL_TEXTURE_2D;

		//generate
		glGenTextures(1, &this->texture);
		glBindTexture(target, this->texture);

		//options
		glTexParameteri(target, GL_TEXTURE_WRAP_S, GL_REPEAT);
		glTexParameteri(target, GL_TEXTURE_WRAP_T, GL_REPEAT);
		glTexParameteri(target, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
		glTexParameteri(target, GL_TEXTURE_MIN_FILTER, GL_NEAREST);

		if (image) //set texture image
		{
			glTexImage2D(target, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, image);
			//glGenerateMipmap(target);
		}
		else //Error
		{
			std::cout << "ERROR::TEXTURE::LOAD_FROM_FILE::FAILED_TO_LOAD_IMAGE_DATA::" << fileName << "\n";
			glDeleteTextures(1, &this->texture);
		}

		//cleanup
		SOIL_free_image_data(image);
		glBindTexture(target, 0);

		return true;
	}

	inline void bind(unsigned int index)
	{
		glActiveTexture(GL_TEXTURE0 + index);
		glBindTexture(GL_TEXTURE_2D, this->texture);
	}

	inline void unbind(GLenum target = GL_TEXTURE_2D)
	{
		glActiveTexture(0);
		glBindTexture(target, 0);
	}
};