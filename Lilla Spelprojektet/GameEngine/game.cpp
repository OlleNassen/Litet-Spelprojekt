#include "game.hpp"

/*int push(lua_State* luaState);
int pop(lua_State* luaState);
int clear(lua_State* luaState);*/


Game::Game()
{
	timePerFrame = sf::seconds(1.f / 60.f);
	
	//initializes window and glew
	initWindow();

	resources = new ResourceManager();
	renderer = new SpriteRenderer(resources->getShader("temp"), &luaVector);

	eventSystem.addVector(&luaVector);

	//Testing lua
	lua_State* L = luaL_newstate();
	luaL_openlibs(L);
	addLuaLibraries(L);
	//luaVector.push_back(L);
	
	if (luaL_loadfile(L, "Resources/Scripts/gameState.lua") || lua_pcall(L, 0, 0, 0))
	{
		fprintf(stderr, "Couldn't load file: %s\n", lua_tostring(L, -1));

	}


}

Game::~Game()
{
	delete this->window;
	delete this->renderer;
	delete this->resources;
}

void Game::run()
{
	sf::Clock clock;
	sf::Time timeSinceLastUpdate = sf::Time::Zero;

	while (!luaVector.empty())
	{
		handleEvents();
		
		sf::Time dt = clock.restart();
		timeSinceLastUpdate += dt;
		
		while (timeSinceLastUpdate > timePerFrame)
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
	}
		
	// release resources...
}

void Game::addLuaLibraries(lua_State* luaState)
{
	lua_pushlightuserdata(luaState, this);
	lua_setglobal(luaState, "Game");
	
	lua_pushcfunction(luaState, push);
	lua_setglobal(luaState, "push");
	lua_pushcfunction(luaState, pop);
	lua_setglobal(luaState, "pop");
	lua_pushcfunction(luaState, clear);
	lua_setglobal(luaState, "clear");

	eventSystem.addLuaRebind(luaState);
	collisionSystem.addLuaPosition(luaState);
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

LuaVector* Game::getVector()
{
	return &luaVector;
}

void Game::update(float deltaTime)
{
	eventSystem.update(deltaTime);
	collisionSystem.update(deltaTime);
}

void Game::draw()
{
	//Fix this and put it somewhere else:
	glm::mat4 projection = glm::ortho(0.0f, 800.0f, 600.0f, 0.0f, -1.0f, 1.0f);

	resources->getShader("sprite")->setInt(0, "image");
	resources->getShader("sprite")->setMatrix4fv(projection, "projection");

	renderer->drawSprite(*resources->getTexture("HansTap.png"), glm::vec2(48, 48), 0.f, glm::vec3(0.0f, 1.0f, 0.0f));
}



void Game::initWindow()
{
	sf::ContextSettings settings;
	settings.depthBits = 24;
	settings.stencilBits = 8;
	settings.antialiasingLevel = 4;
	settings.majorVersion = 4;
	settings.minorVersion = 4;

	window = new sf::Window(sf::VideoMode(WIDTH, HEIGHT), "OpenGL", sf::Style::Default, settings);

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

static int push(lua_State* luaState)
{	
	lua_getglobal(luaState, "Game");
	Game* game = (Game*)lua_touserdata(luaState, -1);
	const char* name = lua_tostring(luaState, -2);
	LuaVector* ptr = game->getVector();

	lua_State* newLua = luaL_newstate();
	luaL_openlibs(newLua);
	game->addLuaLibraries(newLua);

	if (luaL_loadfile(newLua, name) || lua_pcall(newLua, 0, 0, 0))
	{
		fprintf(stderr, "Couldn't load file: %s\n", lua_tostring(newLua, -1));

	}

	ptr->push_back(newLua);

	return 0;
}

static int pop(lua_State* luaState)
{
	lua_getglobal(luaState, "LuaVector");
	Game* game = (Game*)lua_touserdata(luaState, -1);
	LuaVector* ptr = game->getVector();

	lua_close(ptr->back());
	ptr->pop_back();

	return 0;
}

static int clear(lua_State* luaState)
{
	lua_getglobal(luaState, "LuaVector");
	Game* game = (Game*)lua_touserdata(luaState, -1);
	LuaVector* ptr = game->getVector();

	while (!ptr->empty())
	{
		lua_close(ptr->back());
		ptr->pop_back();
	}

	return 0;
}
