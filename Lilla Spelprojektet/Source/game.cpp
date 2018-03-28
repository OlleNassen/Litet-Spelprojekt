#include "game.hpp"

Game::Game()
	:window(new sf::Window(sf::VideoMode(800, 600), "OpenGL", sf::Style::Default, sf::ContextSettings(32)))
{
	this->window->setVerticalSyncEnabled(true);
	// activate the window
	this->window->setActive(true);

	//Set clearing color to red
	glClearColor(1, 0, 0, 1);


	//Testing lua
	lua_State* L = luaL_newstate();

	luaL_openlibs(L);

	luaL_dostring(L, "print('Lua Activated')");

	lua_close(L);
}

Game::~Game()
{
	delete this->window;
}

void Game::run()
{
	// run the main loop
	bool running = true;
	while (running)
	{
		// handle events
		sf::Event event;
		while (window->pollEvent(event))
		{
			if (event.type == sf::Event::Closed)
			{
				// end the program
				running = false;
			}
			else if (event.type == sf::Event::Resized)
			{
				// adjust the viewport when the window is resized
				glViewport(0, 0, event.size.width, event.size.height);
			}
		}

		// clear the buffers
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

		// draw...

		// end the current frame (internally swaps the front and back buffers)
		window->display();
	}

	// release resources...
}

void Game::handleEvents()
{
}
