#include "game.hpp"
#include <lua.hpp>
#include <SFML/Window/Window.hpp>
#include "../Renderer/graphics_system.hpp"
#include "camera.hpp"

#define WIDTH 1280
#define HEIGHT 720

Game::Game()
{
	timePerFrame = sf::seconds(1.f / 60.f);
	wantPop = false;
	wantClear = false;
	//initializes window and glew
	initWindow();

	//Get width and height from lua
	camera = new Camera(WIDTH, HEIGHT);

	eventSystem.addVector(&states);

	//Initializes and starts lua
	lua_State* L = luaL_newstate();
	luaL_openlibs(L);
	addLuaLibraries(L);
	
	if (luaL_loadfile(L, "Resources/Scripts/Setup/Setup.lua") || lua_pcall(L, 0, 0, 0))
	{
		fprintf(stderr, "Couldn't load file: %s\n", lua_tostring(L, -1));

	}
	lua_close(L);

	//camera->zoom(0.5);
	window->setMouseCursorVisible(false);
	window->setMouseCursorGrabbed(true);
}

Game::~Game()
{
	delete this->camera;
	delete this->window;
}

void Game::run()
{	
	sf::Clock clock;
	sf::Time timeSinceLastUpdate = sf::Time::Zero;
	float lastTime = 0.f;

	while (!states.empty() && !wantClear)
	{
		handleEvents();
		sf::Time dt = clock.restart();
		timeSinceLastUpdate += dt;
		
		while (timeSinceLastUpdate > timePerFrame && !wantClear)
		{
			timeSinceLastUpdate -= timePerFrame;

			handleEvents();
			update(timePerFrame.asSeconds());
		}

		// clear the buffers
		glClear(GL_COLOR_BUFFER_BIT);

		// draw...
		this->draw();

		// end the current frame (internally swaps the front and back buffers)
		window->display();

		if (wantPop)
		{
			lua_close(states.back().luaState);
			delete states.back().graphicsSystem;
			states.pop_back();
			wantPop = false;
		}

		

		glClearColor(0.0, 0.0, 0.0, 0.0);
	}
		
	// release resources...
}

void Game::changeResolution(int width, int height)
{
	window->setSize(sf::Vector2u(width, height));
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
		else if (event.type == sf::Event::GainedFocus)
		{
			window->setMouseCursorVisible(false);
		}
		else if (event.type == sf::Event::LostFocus)
		{
			window->setMouseCursorVisible(true);
		}
	}
}

LuaVector* Game::getVector()
{
	return &states;
}

void Game::update(float deltaTime)
{	
	eventSystem.update(deltaTime);	
	
	bool stopUpdate = false;
	
	for (int id = states.size() - 1; id >= 0 && !stopUpdate; id--)
	{
		lua_State* luaState = states[id].luaState;
		
		/* push functions and arguments */
		lua_getglobal(luaState, "update");  /* function to be called */
		lua_pushnumber(luaState, deltaTime);   
		if (lua_pcall(luaState, 1, 1, 0))
		{
			fprintf(stderr, "Couldn't load file: %s\n", lua_tostring(luaState, -1));
			window->setMouseCursorGrabbed(false);
			window->setMouseCursorVisible(true);
			system("pause");
			wantClear = true;
			stopUpdate = true;
		}
		else
		{
			stopUpdate = lua_toboolean(luaState, -1);
			lua_pop(luaState, 1);  /* pop returned value */
		}
	}


	camera->setPosition(states.back().graphicsSystem->getPlayerPos());

}


void Game::draw()
{
	states.back().graphicsSystem->drawTiles(camera->getView(), camera->getProjection());
	states.back().graphicsSystem->drawSprites(camera->getView(), camera->getProjection());
}

void Game::initWindow()
{
	sf::ContextSettings settings;
	settings.depthBits = 24;
	settings.stencilBits = 8;
	settings.antialiasingLevel = 4;
	settings.majorVersion = 4;
	settings.minorVersion = 4;

	window = new sf::Window(sf::VideoMode(WIDTH, HEIGHT), "Game", sf::Style::Default, settings);

	//*** Somewhat fixes mouse problem **/
	sf::Mouse::setPosition(sf::Vector2i(window->getPosition().x + (WIDTH / 2), window->getPosition().y + (HEIGHT / 2)));

	// activate the window
	this->window->setActive(true);

	glewExperimental = GL_TRUE;

	if (glewInit() != GLEW_OK) //Error
	{
		std::cout << "ERROR::GAME::GLEW_INIT_FAILED" << "\n";
	}

	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_BLEND);

	//Set clearing color to red
	glClearColor(0.0,0.0,0.0,0.0);
}

void Game::addLuaLibraries(lua_State* luaState)
{
	lua_pushlightuserdata(luaState, this);
	lua_setglobal(luaState, "Game");

	lua_pushcfunction(luaState, setResolution);
	lua_setglobal(luaState, "setResolution");
	lua_pushcfunction(luaState, setFramerate);
	lua_setglobal(luaState, "setFramerate");

	lua_pushcfunction(luaState, push);
	lua_setglobal(luaState, "push");
	lua_pushcfunction(luaState, pop);
	lua_setglobal(luaState, "pop");
	lua_pushcfunction(luaState, clear);
	lua_setglobal(luaState, "clear");

	eventSystem.addLuaRebind(luaState);
}

int Game::push(lua_State* luaState)
{	
	lua_getglobal(luaState, "Game");
  	Game* game = (Game*)lua_touserdata(luaState, -1);
	const char* name = lua_tostring(luaState, -2);
	LuaVector* ptr = game->getVector();

	lua_State* newLua = luaL_newstate();
	luaL_openlibs(newLua);
	game->addLuaLibraries(newLua);

	State newState;
	newState.luaState = newLua;
	newState.graphicsSystem = new GraphicsSystem(newLua);
	newState.graphicsSystem->addLuaFunctions(newLua);

	if (luaL_loadfile(newLua, name) || lua_pcall(newLua, 0, 0, 0))
	{
		fprintf(stderr, "Couldn't load file: %s\n", lua_tostring(newLua, -1));

	}
	
	ptr->push_back(newState);

	return 0;
}

int Game::pop(lua_State* luaState)
{
	lua_getglobal(luaState, "Game");
	Game* game = (Game*)lua_touserdata(luaState, -1);
	game->wantPop = true;

	return 0;
}

int Game::clear(lua_State* luaState)
{
	lua_getglobal(luaState, "Game");
	Game* game = (Game*)lua_touserdata(luaState, -1);
	game->wantClear = true;

	return 0;
}

int Game::setFramerate(lua_State* luaState)
{
	lua_getglobal(luaState, "Game");
	Game* game = (Game*)lua_touserdata(luaState, -1);
	int fps = lua_tointeger(luaState, -2);

	game->timePerFrame = sf::seconds(1.0f / fps);

	return 0;
}

int Game::setResolution(lua_State* luaState)
{
	lua_getglobal(luaState, "Game");
	Game* game = (Game*)lua_touserdata(luaState, -1);
	int height = lua_tointeger(luaState, -2);
	int width = lua_tointeger(luaState, -3);

	game->changeResolution(width, height);

	return 0;
}