#include "gameState.hpp"

GameState::GameState()
{
	glClearColor(0, 0, 1, 1);

	Shader shader("Resources/Shaders/VertexShaderCore.glsl", "Resources/Shaders/FragmentShaderCore.glsl");
}

GameState::~GameState()
{
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
