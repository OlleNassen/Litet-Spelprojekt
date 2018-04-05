#pragma once
#include "../libs.h"
#include "EventSystem.hpp"
#include "CollisionSystem.hpp"
#include <vector>
#include "../Renderer/spriteRenderer.hpp"
#include "resourceManager.hpp"
static int push(lua_State* luaState);
static int pop(lua_State* luaState);
static int clear(lua_State* luaState);

typedef std::vector<lua_State*> LuaVector;

class Game
{
public:
	Game();
	~Game();
	void addLuaLibraries(lua_State* luaState);
	LuaVector* getVector();
	void run();

private:
	sf::Window* window;
	LuaVector luaVector;
	EventSystem eventSystem;
	CollisionSystem collisionSystem;
	
	SpriteRenderer* renderer;
	ResourceManager* resources;
	


private:
	void handleEvents();
	void update();
	void draw();
	

	void initWindow();
};