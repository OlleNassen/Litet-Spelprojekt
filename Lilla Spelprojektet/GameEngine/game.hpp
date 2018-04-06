#pragma once
#include "../libs.h"
#include "EventSystem.hpp"
#include "CollisionSystem.hpp"
#include <vector>
#include "../Renderer/graphicsSystem.hpp"
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

	sf::Time timePerFrame;

private:
	sf::Window* window;
	LuaVector luaVector;
	EventSystem eventSystem;
	CollisionSystem collisionSystem;
	
	GraphicsSystem* graphicsSystem;
	ResourceManager* resources;
	


private:
	void handleEvents();
	void update(float deltaTime);
	void draw();
	

	void initWindow();
};