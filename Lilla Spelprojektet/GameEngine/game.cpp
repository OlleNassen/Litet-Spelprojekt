#include "game.hpp"
#include <lua.hpp>
#include <SFML/Window/Window.hpp>
#include "../Renderer/graphics_system.hpp"
#include "camera.hpp"

#define WIDTH 1280
#define HEIGHT 720

Game::Game()	
{
	currentState.luaState = nullptr;
	currentState.graphicsSystem = nullptr;
	currentState.audioSystem = nullptr;
	fullscreen = false;
	timePerFrame = sf::seconds(1.f / 60.f);
	//initializes window and glew
	

	//Get width and height from lua
	camera = new Camera(WIDTH, HEIGHT);

	//Initializes and starts lua
	lua_State* L = luaL_newstate();
	luaL_openlibs(L);
	addLuaLibraries(L);
	
	if (luaL_loadfile(L, "Resources/Scripts/Setup/Setup.lua") || lua_pcall(L, 0, 0, 0))
	{
		fprintf(stderr, "Couldn't load file: %s\n", lua_tostring(L, -1));

	}
	lua_close(L);

	initWindow();

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
	std::ifstream is;
	is.open("Resources/highscore.olle");
	for(int i = 0; i < NUM_SCORES; i++)
	{
		is >> highscoreList[i];
	}
	is.close();
	
	sf::Clock clock;
	sf::Time timeSinceLastUpdate = sf::Time::Zero;
	float lastTime = 0.f;

	updateState();

	sf::Music music;
	music.openFromFile("Resources/Sound/malicious.wav");
	music.setLoop(true);
	music.play();

	while (currentState.luaState)
	{
		handleEvents();
		sf::Time dt = clock.restart();
		timeSinceLastUpdate += dt;

		if (eventSystem.getLevel() == 0)
		{
			highscoreClock.restart();
		}
		
		while (currentState.luaState && timeSinceLastUpdate > timePerFrame)
		{
			timeSinceLastUpdate -= timePerFrame;
			handleEvents();
			update(timePerFrame.asSeconds());
		}
		
		currentState.graphicsSystem->draw(
			timePerFrame.asSeconds(), 
			camera->getView(), 
			camera->getProjection(), 
			eventSystem.getLevel(), highscoreList, NUM_SCORES);

		window->display();// end the current frame (internally swaps the front and back buffers)

		if (!stateName.empty())
		{
			updateState();
			clock.restart();
		}
	}

	std::ofstream os;
	os.open("Resources/highscore.olle");
	for (int i = 0; i < NUM_SCORES; i++)
	{
		os << highscoreList[i] << std::endl;
	}
	os.close();
		
	// release resources...
}

void Game::updateState()
{
	if (currentState.luaState)
	{
		lua_close(currentState.luaState);
		delete currentState.graphicsSystem;
		delete currentState.audioSystem;
		currentState.luaState = nullptr;
		currentState.graphicsSystem = nullptr;
		currentState.audioSystem = nullptr;
	}
	
	if (stateName[0] != 'D')
	{
		lua_State* newLua = luaL_newstate();
		luaL_openlibs(newLua);
		addLuaLibraries(newLua);
	
		State newState;
		newState.luaState = newLua;
		newState.graphicsSystem = new GraphicsSystem(shaders);
		newState.graphicsSystem->addLuaFunctions(newLua);
		newState.graphicsSystem->addCamera(camera);
		newState.audioSystem = new AudioSystem();
		newState.audioSystem->addLuaFunctions(newLua);
	
		sf::Clock clock;
		std::cout << "Compiling..." << std::endl;
		clock.restart();
	
		if (luaL_loadfile(newLua, stateName.c_str()) || lua_pcall(newLua, 0, 0, 0))
		{
			fprintf(stderr, "Couldn't load file: %s\n", lua_tostring(newLua, -1));
	
		}
		std::cout << "Compiled: ";
		std::cout << clock.restart().asSeconds() << std::endl;
	
		float tempHighscore = highscoreClock.getElapsedTime().asSeconds();
		if (eventSystem.getLevel() == 1337)
		{
			for (int i = 0; i < NUM_SCORES; i++)
			{
				bool shouldBreak = false;
				if (tempHighscore < highscoreList[i])
				{
					if (i < NUM_SCORES)
					{
						for (int k = NUM_SCORES; k > i; k--)
						{
							highscoreList[k] = highscoreList[k - 1];
						}
					}
					highscoreList[i] = tempHighscore;
					shouldBreak = true;
				}
				if (shouldBreak)
				{
					break;
				}
			}
			newState.graphicsSystem->setHighscore(highscoreList, NUM_SCORES);
		}

		if (eventSystem.getLevel() == 1338)
		{
			newState.graphicsSystem->setHighscore(highscoreList, NUM_SCORES);
		}

		currentState = newState;
	
		stateName = "";
	
	
	}
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

void Game::update(float deltaTime)
{	
	eventSystem.update(deltaTime);	
			
	/* push functions and arguments */
	lua_getglobal(currentState.luaState, "update");  /* function to be called */
	lua_pushnumber(currentState.luaState, deltaTime);
	if (lua_pcall(currentState.luaState, 1, 1, 0))
	{
		fprintf(stderr, "Couldn't load file: %s\n", lua_tostring(currentState.luaState, -1));
		window->setMouseCursorGrabbed(false);
		window->setMouseCursorVisible(true);
		system("pause");
		stateName = "D";
	}
	currentState.graphicsSystem->update(deltaTime);
}

void Game::initWindow()
{
	sf::ContextSettings settings;
	settings.depthBits = 24;
	settings.stencilBits = 8;
	settings.antialiasingLevel = 4;
	settings.majorVersion = 4;
	settings.minorVersion = 4;

	if (fullscreen)
	{
		window = new sf::Window(sf::VideoMode(WIDTH, HEIGHT), "Game", sf::Style::Fullscreen, settings);
	}
	else
	{
		window = new sf::Window(sf::VideoMode(WIDTH, HEIGHT), "Game", sf::Style::Default, settings);
	}

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

	shaders.basic.load("Resources/Shaders/basicShader.vert", "Resources/Shaders/basicShader.frag");
	shaders.shader2d.load("Resources/Shaders/2d_shader.vert", "Resources/Shaders/2d_shader.frag");
	shaders.amazing.load("Resources/Shaders/amazing_shader.vert", "Resources/Shaders/amazing_shader.frag");
	shaders.particle.load("Resources/Shaders/particle_shader.vert", "Resources/Shaders/particle_shader.frag");
	shaders.trash.load("Resources/Shaders/trash.vert", "Resources/Shaders/trash.frag");
	shaders.billboard.load("Resources/Shaders/billboard.vert", "Resources/Shaders/billboard.frag");
	shaders.mouseEffect.load("Resources/Shaders/mouse_effect.vert", "Resources/Shaders/mouse_effect.frag");
	shaders.postProcessing.load("Resources/Shaders/post_processing.vert", "Resources/Shaders/post_processing.frag");
	shaders.text.load("Resources/Shaders/text.vert", "Resources/Shaders/text.frag");
}

void Game::addLuaLibraries(lua_State* luaState)
{
	lua_pushlightuserdata(luaState, this);
	lua_setglobal(luaState, "Game");

	lua_pushcfunction(luaState, setResolution);
	lua_setglobal(luaState, "setResolution");
	lua_pushcfunction(luaState, setFramerate);
	lua_setglobal(luaState, "setFramerate");

	lua_pushcfunction(luaState, newState);
	lua_setglobal(luaState, "newState");
	lua_pushcfunction(luaState, deleteState);
	lua_setglobal(luaState, "deleteState");

	lua_pushcfunction(luaState, getCameraPosition);
	lua_setglobal(luaState, "getCameraPosition");

	eventSystem.addLuaRebind(luaState);
}

int Game::newState(lua_State* luaState)
{	
	lua_getglobal(luaState, "Game");
  	Game* game = (Game*)lua_touserdata(luaState, -1);
	const char* name = lua_tostring(luaState, -2);
	game->stateName = name;
		
	return 0;
}

int Game::deleteState(lua_State* luaState)
{
	lua_getglobal(luaState, "Game");
	Game* game = (Game*)lua_touserdata(luaState, -1);
	game->stateName = "D";

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
	bool fullscreen = lua_toboolean(luaState, -2);


	game->fullscreen = fullscreen;

	return 0;
}

int Game::getCameraPosition(lua_State* luaState)
{
	lua_getglobal(luaState, "Game");
	Game* game = (Game*)lua_touserdata(luaState, -1);

	lua_pushnumber(luaState, game->camera->getCenter().x);
	lua_pushnumber(luaState, game->camera->getCenter().y);

	return 2;
}