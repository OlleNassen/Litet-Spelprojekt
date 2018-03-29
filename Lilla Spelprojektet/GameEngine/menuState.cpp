#include "menuState.hpp"

MenuState::MenuState()
{

}

MenuState::~MenuState()
{
}

void MenuState::handleInput()
{
	if (sf::Keyboard::isKeyPressed(sf::Keyboard::Left))
	{
		// left key is pressed: move our character
		changeState = true;
	}

}

void MenuState::update()
{
}

void MenuState::draw() const
{
}

void MenuState::pause()
{
}

void MenuState::resume()
{
}
