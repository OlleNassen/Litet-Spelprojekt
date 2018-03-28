#include "menuState.hpp"

MenuState::MenuState()
{

}

MenuState::~MenuState()
{
}

void MenuState::handleEvents(sf::Window* window)
{
	// handle events
	sf::Event event;
	while (window->pollEvent(event))
	{
		if (event.type == sf::Event::Closed)
		{
			// end the program
			window->close();
		}
		else if (event.type == sf::Event::Resized)
		{
			// adjust the viewport when the window is resized
			glViewport(0, 0, event.size.width, event.size.height);
		}
	}
}

void MenuState::handleInput()
{
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
