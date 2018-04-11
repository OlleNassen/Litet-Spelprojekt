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
	std::vector<Sprite*>goombas;
	std::vector<Sprite*> bosses;

public:
	GraphicsSystem(std::vector<lua_State*>* luaStateVector);
	~GraphicsSystem();

	void addVector(std::vector<lua_State*>* vector);

	void drawPlayer(glm::mat4& view, const glm::mat4& projection);
	void drawTiles(glm::mat4& view, const glm::mat4& projection);
	void drawBossman(glm::mat4& view, const glm::mat4& projection);
	void drawGoombas(glm::mat4& view, const glm::mat4& projection);

	void addLuaFunctions(lua_State* luaState);

	glm::vec2 getPlayerPosition(lua_State* luaState)const;
private:
	void loadTextures();
	void loadShaders();
	
	glm::vec2 getBossPosition(lua_State* luaState) const;
	glm::vec2 getGoombaPosition(lua_State* luaState)const;
	static int loadTileMap(lua_State* luaState);
};

