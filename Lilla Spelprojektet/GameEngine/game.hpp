#pragma once
#include "event_system.hpp"
#include "../Renderer/Shader.hpp"
#include "audio_system.hpp"

#include <iostream>


namespace sf
{
	class Window;
};

struct lua_State;
class GraphicsSystem;
class Camera;

struct State
{
	lua_State* luaState;
	GraphicsSystem* graphicsSystem;
	AudioSystem* audioSystem;

};

struct ShaderStruct
{
	Shader basic;
	Shader shader2d;
	Shader amazing;
	Shader particle;
	Shader trash;
	Shader billboard;
};

typedef std::vector<State> LuaVector;

class Game
{
private:
	sf::Window* window;
	EventSystem eventSystem;
	Camera* camera;
	State currentState;
	ShaderStruct shaders;
	std::string stateName;

public:
	Game();
	~Game();

	void run();

	sf::Time timePerFrame;
	void changeResolution(int width, int height);

private:
	void handleEvents();
	void update(float deltaTime);
	void updateState();
	void draw();

	void initWindow();
	
	//Lua stuff
	void addLuaLibraries(lua_State* luaState);
	static int newState(lua_State* luaState);
	static int deleteState(lua_State* luaState);
	static int setFramerate(lua_State* luaState);
	static int setResolution(lua_State* luaState);
	static int getCameraPosition(lua_State* luaState);
};