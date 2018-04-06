#pragma once
#include"Shader.hpp"
#include "Texture2D.hpp"

class GraphicsSystem
{
public:
	GraphicsSystem(Shader *shader, std::vector<lua_State*>* luaStateVector);
	~GraphicsSystem();
	void drawSprite(Texture2D &texture,
		glm::vec2 size, GLfloat rotate, glm::vec3 color);

	void addVector(std::vector<lua_State*>* vector);
	void initTiles();

	void drawTiles(Texture2D &texture,
		glm::vec2 size, GLfloat rotate, glm::vec3 color);

private:
	unsigned int* tileMap;
	Shader *shader;
	GLuint quadVAO;
	std::vector<GLuint> tileVAO;
	void initRenderData();
	std::vector<lua_State*>* luaVector;
};

