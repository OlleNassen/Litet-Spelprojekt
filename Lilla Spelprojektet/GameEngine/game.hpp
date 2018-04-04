#pragma once
#include "../libs.h"
#include "gameState.hpp"
#include "menuState.hpp"
#include "EventSystem.hpp"
#include <vector>

class Game
{
private:
	sf::Window* window;
	std::stack<State*> currentState;
	EventSystem eventSystem;
	std::vector<lua_State*> luaStates;

public:
	Game();
	~Game();
	void run();
private:
	void handleInput();
	void handleEvents();
	void draw();
	void update();

	void initWindow();
};