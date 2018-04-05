#pragma once
#include "../libs.h"
#include "EventSystem.hpp"
//#include "CollisionSystem.hpp"
#include <vector>
#include "../Renderer/spriteRenderer.hpp"
#include "resourceManager.hpp"

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
	SpriteRenderer* renderer;
	ResourceManager* resources;
	


private:
	void addLuaLibraries(lua_State* luaState);
	void handleEvents();
	void update();
	void draw();
	

	void initWindow();
};