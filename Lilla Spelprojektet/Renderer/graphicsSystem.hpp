#pragma once
#include"Shader.hpp"
#include "Texture2D.hpp"
#include "sprite.hpp"

class GraphicsSystem
{
private:
	unsigned int* tileMap;
	GLuint quadVAO;
	std::vector<GLuint> tileVAO;

	std::vector<lua_State*>* luaVector;

	std::vector<Shader*> shaders;
	std::vector<Texture2D*> textures;
	std::vector<Sprite*>sprites;

public:
	GraphicsSystem(std::vector<lua_State*>* luaStateVector);
	~GraphicsSystem();

	void drawSprites(const glm::mat4& view, const glm::mat4& projection);

	void addVector(std::vector<lua_State*>* vector);
	void initTiles();

	void drawTiles(const glm::mat4& view, const glm::mat4& projection);

private:
	void loadTextures();
	void loadShaders();
};

