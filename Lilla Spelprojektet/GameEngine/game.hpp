#pragma once
#include "../libs.h"
#include "gameState.hpp"
#include "menuState.hpp"
#include "EventSystem.hpp"

class Game
{
private:
	sf::Window* window;
	std::stack<State*> currentState;
	EventSystem eventSystem;

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