#include "game.hpp"

Game::Game()
	:window(new sf::Window(sf::VideoMode(800, 600), "OpenGL", sf::Style::Default, sf::ContextSettings(32)))
{


	this->window->setVerticalSyncEnabled(true);
	// activate the window
	this->window->setActive(true);

	//Set clearing color to red
	glClearColor(1, 0, 0, 1);

	//Add game state
	currentState.push(new MenuState);

	//Testing lua
	lua_State* L = luaL_newstate();

	luaL_openlibs(L);

	luaL_dostring(L, "print('Lua Activated')");

	lua_close(L);

}

Game::~Game()
{
	for (int i = 0; i < currentState.size(); ++i)
	{
		delete currentState.top();
		currentState.pop();
	}

	delete this->window;
}

void Game::run()
{
	// run the main loop
	

	while (currentState.top()->isRunning())
	{
		
		if (currentState.top()->getChangeState())
		{
			//Change to the next state.. Remove this and add enums instead?
			State* ptr = dynamic_cast<MenuState*>(currentState.top());

			if (ptr != nullptr)
			{
				currentState.push(new GameState);
			}

		}

		//handle input
		this->handleInput();

		//update
		this->update();

		//handle events
		this->handleEvents();

		// clear the buffers
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

		// draw...
		this->draw();

		// end the current frame (internally swaps the front and back buffers)
		window->display();
	}
	// release resources...
}

void Game::handleInput()
{
	currentState.top()->handleInput();
}

void Game::handleEvents()
{
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

void Game::draw()
{
	currentState.top()->draw();
}

void Game::update()
{
	currentState.top()->update();
}
