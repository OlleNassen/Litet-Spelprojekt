#pragma once

#include <gl/glew.h>
#include <glm/glm.hpp>

#include "texture_2d.hpp"
#include "shader.hpp"

class PostProcessor
{
public:
	
	// State
	Shader* postProcessingShader;
	Texture2D texture;
	unsigned int width;
	unsigned int height;
	
	// Options
	GLboolean confuse, lowHealth, shake, flash;
	glm::vec2 curtain;
	
	// Constructor
	PostProcessor(Shader* shader, unsigned int width, unsigned int height);
	
	// Prepares the postprocessor's framebuffer operations before rendering the game
	void beginRender();
	
	// Should be called after rendering the game, so it stores all the rendered data into a texture object
	void endRender();
	
	// Renders the PostProcessor texture quad (as a screen-encompassing large sprite)
	void render(GLfloat time);

private:
	// Render state
	GLuint MSFBO, FBO; // MSFBO = Multisampled FBO. FBO is regular, used for blitting MS color-buffer to texture
	GLuint RBO; // RBO is used for multisampled color buffer
	GLuint VAO;
	// Initialize quad for rendering postprocessing texture
	void initRenderData();
};

