#pragma once
#include "event_system.hpp"
#include "../Renderer/Shader.hpp"
#include "audio_system.hpp"
#include "compute_shader.hpp"


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
	ComputeShader compShader;
};

typedef std::vector<State> LuaVector;

class Game
{
private:
	bool wantPop;
	bool wantClear;
	sf::Window* window;
	EventSystem eventSystem;
	Camera* camera;
	std::vector<State> states;
	ShaderStruct shaders;

	

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
	static int getCameraPosition(lua_State* luaState);
};