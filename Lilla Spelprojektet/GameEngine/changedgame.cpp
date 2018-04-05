#include "game.hpp"

int push(lua_State* luaState)
{
	lua_getglobal(luaState, "LuaVector");
	LuaVector* ptr = (LuaVector*)lua_touserdata(luaState, -1);

	lua_State* newLua = luaL_newstate();
	ptr->push_back(newLua);
	
	return 0;
}

int pop(lua_State* luaState)
{
	lua_getglobal(luaState, "LuaVector");
	LuaVector* ptr = (LuaVector*)lua_touserdata(luaState, -1);

	lua_close(ptr->back());
	ptr->pop_back();

	return 0;
}

int clear(lua_State* luaState)
{
	lua_getglobal(luaState, "LuaVector");
	LuaVector* ptr = (LuaVector*)lua_touserdata(luaState, -1);

	while (!ptr->empty())
	{
		lua_close(ptr->back());
		ptr->pop_back();
	}

	return 0;
}

Game::Game()
{
	//initializes window and glew
	initWindow();

	//Testing lua
	lua_State* L = luaL_newstate();
	luaL_openlibs(L);
	addLuaLibraries(L);
	//luaL_loadfile(L, "vector.lua");
	if (luaL_loadfile(L, "Resources/Scripts/vector.lua"))
	{
		fprintf(stderr, "Couldn't load file: %s\n", lua_tostring(L, -1));

	}
	//lua_close(L);

}

Game::~Game()
{
	delete this->window;
}

void Game::run()
{
	// run the main loop
	
	while (true || !luaVector.empty())
	{
		//handle events
		this->handleEvents();
		
		//update		
		this->update();		

		// clear the buffers
		glClear(GL_COLOR_BUFFER_BIT);

		// draw...
		this->draw();

		// end the current frame (internally swaps the front and back buffers)
		window->display();
	}
	// release resources...
}

void Game::addLuaLibraries(lua_State* luaState)
{
	lua_pushlightuserdata(luaState, &luaVector);
	lua_setglobal(luaState, "LuaVector");
	lua_pop(luaState, 1);
	
	lua_pushcfunction(luaState, push);
	lua_setglobal(luaState, "push");
	lua_pop(luaState, 1);
	lua_pushcfunction(luaState, push);
	lua_setglobal(luaState, "pop");
	lua_pop(luaState, 1);
	lua_pushcfunction(luaState, push);
	lua_setglobal(luaState, "clear");
	lua_pop(luaState, 1);
}


void Game::handleEvents()
{
	sf::Event event;
	while (window->pollEvent(event))
	{
		eventSystem.setEvent(event);

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

void Game::update()
{
	eventSystem.update(1);
	//collisionSystem.update(1);
}

void Game::draw()
{
	//currentState.top()->draw();
}



void Game::initWindow()
{
	sf::ContextSettings settings;
	settings.depthBits = 24;
	settings.stencilBits = 8;
	settings.antialiasingLevel = 4;
	settings.majorVersion = 4;
	settings.minorVersion = 4;

	window = new sf::Window(sf::VideoMode(800, 600), "OpenGL", sf::Style::Default, settings);

	//glViewport(320, 480, )

	this->window->setVerticalSyncEnabled(true);
	// activate the window
	this->window->setActive(true);

	glewExperimental = GL_TRUE;

	if (glewInit() != GLEW_OK) //Error
	{
		std::cout << "ERROR::GAME::GLEW_INIT_FAILED" << "\n";
	}

	//Set clearing color to red
	glClearColor(1, 0, 0, 1);
}
