#pragma once
#include "state.hpp"
#include <SFML\Window.hpp>
#include <SFML\OpenGL.hpp>

class MenuState :public State
{
private:

public:
	MenuState();
	~MenuState();

	void handleEvents(sf::Window* window) override;
	void handleInput() override;
	void update() override;
	void draw()const override;

	void pause() override;
	void resume() override;
};