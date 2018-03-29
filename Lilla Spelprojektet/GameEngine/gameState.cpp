#include "gameState.hpp"

GameState::GameState()
{
	glClearColor(0, 0, 1, 1);

	Shader shader("Resources/Shaders/VertexShaderCore.glsl", "Resources/Shaders/FragmentShaderCore.glsl");
	shader.use();
}

GameState::~GameState()
{
}

void GameState::handleInput()
{

	if (sf::Keyboard::isKeyPressed(sf::Keyboard::Right))
	{
		// left key is pressed: move our character
		running = false;
	}

	
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