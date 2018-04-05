#pragma once
#include "../libs.h"
#include "gameState.hpp"
#include "menuState.hpp"
#include "EventSystem.hpp"
//#include "CollisionSystem.hpp"
#include <vector>

typedef std::vector<lua_State*> LuaVector;

class Game
{
public:
	Game();
	~Game();
	void run();

private:
	sf::Window* window;
	EventSystem eventSystem;
	//CollisionSystem collisionSystem;
	LuaVector luaVector;


private:
	void addLuaLibraries(lua_State* luaState);
	void handleEvents();
	void update();
	void draw();
	

	void initWindow();
};