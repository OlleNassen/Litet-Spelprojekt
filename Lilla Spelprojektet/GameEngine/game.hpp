#pragma once
#include "../libs.h"
#include "gameState.hpp"

class Game
{
private:
	sf::Window* window;
	std::stack<State*> currentState;

public:
	Game();
	~Game();

	void run();
private:
	void handleInput();
	void handleEvents();
	void draw();
	void update();
};