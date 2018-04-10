#pragma once
#include "../libs.h"
#include "EventSystem.hpp"
#include "CollisionSystem.hpp"
#include "../Renderer/graphicsSystem.hpp"
#include "camera.hpp"

typedef std::vector<lua_State*> LuaVector;

class Game
{
private:
	sf::Window* window;
	LuaVector luaVector;
	EventSystem eventSystem;
	CollisionSystem collisionSystem;
	GraphicsSystem* graphicsSystem;
	Camera* camera;

public:
	Game();
	~Game();

	void run();

	LuaVector* getVector();
	sf::Time timePerFrame;
	void changeResolution(int width, int height);

private:
	void handleEvents();
	void update(float deltaTime);
	void draw();

	void initWindow();

	//Lua stuff
	void addLuaLibraries(lua_State* luaState);
	static int push(lua_State* luaState);
	static int pop(lua_State* luaState);
	static int clear(lua_State* luaState);
	static int setFramerate(lua_State* luaState);
	static int setResolution(lua_State* luaState);
};