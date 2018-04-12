#pragma once
#include"Shader.hpp"
#include "Texture2D.hpp"
#include "sprite.hpp"
#include "../libs.h"

class GraphicsSystem
{
private:
	std::vector<int> tileMap;
	std::vector<Sprite*> tiles;

	std::vector<lua_State*>* luaVector;

	std::vector<Shader*> shaders;
	std::vector<Texture2D*> textures;
	std::vector<Sprite*>players;

	

public:
	GraphicsSystem(std::vector<lua_State*>* luaStateVector);
	~GraphicsSystem();

	void addVector(std::vector<lua_State*>* vector);

	void drawSprites(glm::mat4& view, const glm::mat4& projection);
	void drawTiles(glm::mat4& view, const glm::mat4& projection);

	void addLuaFunctions(lua_State* luaState);
	sf::Vector2f getPlayerPos() const;
private:
	void loadShaders();
	
	static int loadTileMap(lua_State* luaState);

	static int newtexture(lua_State* luaState);
	static int newsprite(lua_State* luaState);
	static int spritepos(lua_State* luaState);

};

