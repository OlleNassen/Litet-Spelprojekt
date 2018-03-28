#include "gameState.hpp"

GameState::GameState()
{
	glClearColor(0, 0, 1, 1);
}

GameState::~GameState()
{
}

void GameState::handleEvents(sf::Window** window)
{
	// handle events
	sf::Event event;
	while ((*window)->pollEvent(event))
	{
		if (event.type == sf::Event::Closed)
		{
			// end the program
			(*window)->close();
		}
		else if (event.type == sf::Event::Resized)
		{
			// adjust the viewport when the window is resized
			glViewport(0, 0, event.size.width, event.size.height);
		}
	}
}

void GameState::handleInput()
{
}

void GameState::update()
{
}

void GameState::draw() const
{
}

void GameState::pause()
{
}

void GameState::resume()
{
}
