#pragma once
#include "../libs.h"

class Camera
{
private:

	GLfloat windowWidth;
	GLfloat windowHeight;

public:
	Camera(GLuint width, GLuint height);
	~Camera();

};