#pragma once
#include"Shader.hpp"
#include "texture_2d.hpp"
#include "sprite.hpp"
#include "../libs.h"

class GraphicsSystem
{
private:
	std::vector<int> tileMap;
	std::vector<Texture2D*> tileTextures;
	std::vector<Sprite*> tiles;
	Sprite* background;

	std::vector<lua_State*>* luaVector;

	std::vector<Shader*> shaders;
	std::vector<Texture2D*> textures;
	std::vector<std::vector<Sprite*>> sprites;
	std::vector<glm::vec3>lights;

	Sprite* test;

public:
	GraphicsSystem(std::vector<lua_State*>* luaStateVector);
	~GraphicsSystem();
	void pushSpriteVector();
	void popSpriteVector();
	void addVector(std::vector<lua_State*>* vector);

	void drawSprites(const glm::mat4& view, const glm::mat4& projection);
	void drawTiles(const glm::mat4& view, const glm::mat4& projection);

	void addLuaFunctions(lua_State* luaState);
	sf::Vector2f getPlayerPos() const;
private:
	void loadShaders();
	
	static int loadTileMap(lua_State* luaState);
	static int reloadTile(lua_State* luaState);

	static int newtexture(lua_State* luaState);
	static int newsprite(lua_State* luaState);
	static int spritepos(lua_State* luaState);

	static int newtiletexture(lua_State* luaState);
};

