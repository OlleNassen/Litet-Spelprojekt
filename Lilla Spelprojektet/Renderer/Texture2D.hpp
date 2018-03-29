#pragma once

#include"../libs.h"

class Texture2D
{
private:
	GLuint texture;

public:
	Texture2D()
	{
		this->texture = 0;
	}

	Texture2D(char* fileName)
	{
		//load image
		int width = 0;
		int height = 0;
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
			glGenerateMipmap(target);
		}
		else //Error
		{
			std::cout << "ERROR::TEXTURE::FAILED_TO_LOAD_IMAGE_DATA::" << fileName << "\n";
			glDeleteTextures(1, &this->texture);
		}

		//cleanup
		SOIL_free_image_data(image);
		glBindTexture(target, 0);
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
	bool loadFromFile(char* fileName)
	{
		if (this->texture) //Already exists
		{
			glDeleteTextures(1, &this->texture);
			this->texture = 0;
		}

		//load image
		int width = 0;
		int height = 0;
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
			glGenerateMipmap(target);
		}
		else //Error
		{
			std::cout << "ERROR::TEXTURE::LOAD_FROM_FILE::FAILED_TO_LOAD_IMAGE_DATA::" << fileName << "\n";
			glDeleteTextures(1, &this->texture);
		}

		//cleanup
		SOIL_free_image_data(image);
		glBindTexture(target, 0);
	}
};