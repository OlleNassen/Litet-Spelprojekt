#include "graphics_system.hpp"
#include"Shader.hpp"
#include "texture_2d.hpp"
#include "sprite.hpp"
#include "../GameEngine/camera.hpp"
#include <lua.hpp>
#include <SFML/Window.hpp> // TEMP FOR SHADOWS
#include <iostream>
#define BUFFER_OFFSET(i) ((char *)nullptr + (i))

#define WIDTH 1280
#define HEIGHT 720

GraphicsSystem::GraphicsSystem(ShaderStruct& shad)
	: shaders(shad)
{
	highscore = nullptr;
	drawLaser = false;
	
	tileMap.reserve(sizeof(int) * 100);
	visibleTiles.reserve(sizeof(bool) * 100);
	tileTextures.reserve(sizeof(Texture2D) * 100);
	tiles.reserve(sizeof(Sprite) * 100);
	textures.reserve(sizeof(Texture2D) * 100);
	sprites.reserve(sizeof(Sprite) * 100);
	backgrounds.reserve(sizeof(Sprite) * 25);

	textures.push_back(Texture2D());
	textures.back().loadFromFile("Resources/Sprites/laserParticle_diffuse.png");

	textures.push_back(Texture2D());
	textures.back().loadFromFile("Resources/Sprites/laserParticle_normal.png");

	textures.push_back(Texture2D());
	textures.back().loadFromFile("Resources/Sprites/starParticle_diffuse.png");

	textures.push_back(Texture2D());
	textures.back().loadFromFile("Resources/Sprites/starParticle_normal.png");

	
	laserEffect = new ParticleEmitter(&shaders.particle, &textures[0]);
	
	billboards = new Billboard(&shaders.billboard, &textures[0]);

	mouseEffect = new MouseEffect(&shaders.mouseEffect, &textures[0]);

	currentLevel = new Text(&shaders.text);

	postProcessor = new PostProcessor(&shaders.postProcessing, WIDTH, HEIGHT);
	
	for (int i = 0; i < NUM_LIGHTS; i++)
	{
		lights.positions[i] = glm::vec3(-10000, -10000, 0);
		lights.colors[i] = glm::vec4(0, 0, 0, 0);
	}

	std::cout << "GS constructor done!" << std::endl;
	
	//postProcessor->lowHealth = true;
	//postProcessor->confuse = true;
	//postProcessor->shake = true;
	//postProcessor->flash = true;
	//postProcessor->curtain = glm::vec2(1, 0);
}

GraphicsSystem::~GraphicsSystem()
{
	delete laserEffect;
	delete billboards;
	delete mouseEffect;
	delete postProcessor;
	delete currentLevel;

	if (highscore)
		delete highscore;
}

void GraphicsSystem::draw(
	float deltaTime, const glm::mat4& view, 
	const glm::mat4& projection, int level, float scores[], int numScores)
{
	postProcessor->beginRender();
	drawTiles(camera->getView(), camera->getProjection());
	drawSprites(camera->getView(), camera->getProjection());
	drawLevelText(projection, level);
	if (highscore)
	{
		displayHighscore(projection, scores, numScores);
	}

	postProcessor->endRender();
	postProcessor->render(deltaTime);

	

}

void GraphicsSystem::drawLevelText(const glm::mat4 & projection, int level)
{
	if (textClock.getElapsedTime().asSeconds() < 3)
	{
		switch (level)
		{
		case 0:
			break;

		case 1337:
			billboards->setColor(glm::vec4(1, 1, 0, 1));
			break;

		case 1338:
			break;

		case 420:
			billboards->setColor(glm::vec4(1, 0, 0, 1));
			break;
		case 8055:
			currentLevel->RenderText(
				"Boss Room",
				400, 100, 1, glm::vec3(1, 1, 1), projection);
			break;

		default:
			billboards->setColor(glm::vec4(0.1, 0.2, 0.8, 0.5));
			currentLevel->RenderText(
				"Welcome To Level " + std::to_string(level), 
				400, 100, 1, glm::vec3(1, 1, 1), projection);
			break;
		}
	}

}

void GraphicsSystem::drawSprites(const glm::mat4& view, const glm::mat4& projection)
{	
	if (sprites.size() > 0)
	{
		for (int itr = sprites.size() - 1; itr >= 0; itr--)
		{

			shaders.amazing.use();
			glUniform3fv(glGetUniformLocation(shaders.amazing.getID(), "lightPos"), NUM_LIGHTS, &lights.positions[0][0]);
			glUniform4fv(glGetUniformLocation(shaders.amazing.getID(), "lightColor"), NUM_LIGHTS, &lights.colors[0][0]);
			shaders.amazing.unuse();

			glm::vec2 position;
			position.x = sprites[itr].posX;
			position.y = sprites[itr].posY;


			shaders.amazing.setVector3f(glm::vec3(1, 0, 0), "status");

			sprites[itr].draw(position, view, projection);
		}
	}
	
	//::.. Collins Laser ..:://
	
	if (drawLaser)
	{	
		laserEffect->render(view, projection);
	}
	mouseEffect->render(view, projection);
}

void GraphicsSystem::drawTiles(const glm::mat4& view, const glm::mat4& projection)
{		
	for (int i = 0; i < this->backgrounds.size(); i++)
	{
		shaders.basic.use();
		backgrounds[i].draw(glm::vec2(
			backgrounds[i].posX,
			backgrounds[i].posY), view, projection);
	}

	billboards->render(view, projection);

	if (tileMap.size() > 0)
	{	
		shaders.amazing.use();
		glUniform3fv(glGetUniformLocation(shaders.amazing.getID(), "lightPos"), NUM_LIGHTS, &lights.positions[0][0]);
		glUniform4fv(glGetUniformLocation(shaders.amazing.getID(), "lightColor"), NUM_LIGHTS, &lights.colors[0][0]);

		for (int y = (camera->getPosition().y - HEIGHT/2) / 48 - 1; y < (camera->getPosition().y + HEIGHT/2) / 48; y++)
		{
			for (int x = (camera->getPosition().x - WIDTH/2) / 48 - 1; x < (camera->getPosition().x + WIDTH/2) / 48; x++)
			{
				if (x >= 0 && y >= 0 && x < tileMap[0] && y < tileMap[1] 
					&& tileMap[x + 2 + y * tileMap[0]] != 0)
				{
					tiles[tileMap[x + 2 + y * tileMap[0]] - 1].draw(glm::vec2(x * 48, y * 48), view, projection);					
				}
			}
		}
		shaders.amazing.unuse();
	}
}

void GraphicsSystem::displayHighscore(const glm::mat4& projection, float scores[], int numScores)
{
	for (int i = 0; i < numScores; i++)
	{
		highscore->RenderHighscore(std::to_string(scores[i]), 0, i * 50, 1, glm::vec3(1, 1, 1), i, projection);
	}
}

void GraphicsSystem::addCamera(Camera* cam)
{
	camera = cam;
}

void GraphicsSystem::update(float deltaTime)
{
	mouseEffect->update(glm::vec2(getPixie().x, getPixie().y), deltaTime);

	laserEffect->updateLaser(0.00016f,
		glm::vec2(sprites[0].posX, sprites[0].posY), glm::vec2(getPixie().x, getPixie().y));

	billboards->update(deltaTime);

	updateCamera();

	//postProcessor->shake = sf::Keyboard::isKeyPressed(sf::Keyboard::K);
	if (postProcessor->curtain.x < 2)
	{
		postProcessor->curtain.x += deltaTime;
	}	
}

void GraphicsSystem::updateCamera()
{
	sf::Vector2f camPos(getPlayerPos());
	camera->setPosition(camPos);

	if (tileMap.size() > 0)
	{
		if (camPos.x < WIDTH / 2.0f)
		{
			camPos.x += WIDTH / 2.0f - camPos.x;
		}
		if (camPos.y < HEIGHT / 2.0f)
		{
			camPos.y += HEIGHT / 2.0f - camPos.y;
		}

		if (camPos.x > tileMap[0] * 48 - WIDTH / 2.0f)
		{
			camPos.x -= camPos.x - (tileMap[0] * 48 - WIDTH / 2.0f);
		}
		if (camPos.y > tileMap[1] * 48 - HEIGHT / 2.0f)
		{
			camPos.y -= camPos.y - (tileMap[1] * 48 - HEIGHT / 2.0f);
		}
		camera->setPosition(camPos);
	}
}

void GraphicsSystem::addLuaFunctions(lua_State* luaState)
{
	lua_pushlightuserdata(luaState, this);
	lua_setglobal(luaState, "GraphicsSystem");

	lua_pushcfunction(luaState, loadTileMap);
	lua_setglobal(luaState, "loadTileGraphics");

	lua_pushcfunction(luaState, reloadTile);
	lua_setglobal(luaState, "reloadTile");

	lua_pushcfunction(luaState, newtexture);
	lua_setglobal(luaState, "newTexture");

	lua_pushcfunction(luaState, settexture);
	lua_setglobal(luaState, "setTexture");

	lua_pushcfunction(luaState, newsprite);
	lua_setglobal(luaState, "newSprite");

	lua_pushcfunction(luaState, newLight);
	lua_setglobal(luaState, "newLight");

	lua_pushcfunction(luaState, spritesize);
	lua_setglobal(luaState, "spriteSize");

	lua_pushcfunction(luaState, spritepos);
	lua_setglobal(luaState, "spritePos");

	lua_pushcfunction(luaState, setspriterect);
	lua_setglobal(luaState, "setSpriteRect");

	lua_pushcfunction(luaState, newtiletexture);
	lua_setglobal(luaState, "tileTexture");

	lua_pushcfunction(luaState, clearTileMap);
	lua_setglobal(luaState, "clearTileMap");

	lua_pushcfunction(luaState, newbackground);
	lua_setglobal(luaState, "newBackground");

	lua_pushcfunction(luaState, backgroundpos);
	lua_setglobal(luaState, "backgroundPos");

	lua_pushcfunction(luaState, laseron);
	lua_setglobal(luaState, "laserOn");

	lua_pushcfunction(luaState, laseroff);
	lua_setglobal(luaState, "laserOff");

	lua_pushcfunction(luaState, flashon);
	lua_setglobal(luaState, "flashOn");

	lua_pushcfunction(luaState, flashoff);
	lua_setglobal(luaState, "flashOff");

	lua_pushcfunction(luaState, shakeon);
	lua_setglobal(luaState, "shakeOn");

	lua_pushcfunction(luaState, shakeoff);
	lua_setglobal(luaState, "shakeOff");

	lua_pushcfunction(luaState, lowhealthon);
	lua_setglobal(luaState, "lowHealthOn");

	lua_pushcfunction(luaState, lowhealthoff);
	lua_setglobal(luaState, "lowHealthOff");
}

sf::Vector2f GraphicsSystem::getPlayerPos() const
{
	sf::Vector2f vec(0, 0);

	if (sprites.size() > 0)
	{
		vec = sf::Vector2f(sprites[0].posX, sprites[0].posY);
	}
	
	return vec;
}

sf::Vector2f GraphicsSystem::getPixie() const
{
	sf::Vector2f vec(0, 0);

	if (sprites.size() > 0)
	{
		vec = sf::Vector2f(sprites[1].posX, sprites[1].posY);
	}

	return vec;
}

void GraphicsSystem::setHighscore(float* highscoreText, int index)
{
	highscore = new Text(&shaders.text);
	if (index != -1)
	{
		highscore->setPlayerScore(index);
	}
}

int GraphicsSystem::loadTileMap(lua_State * luaState)
{
	lua_getglobal(luaState, "GraphicsSystem");
	GraphicsSystem* ptr = (GraphicsSystem*)lua_touserdata(luaState, -1);
	ptr->tileMap.push_back(lua_tointeger(luaState, -2));
	ptr->visibleTiles.push_back(true);

	return 0;
}

int GraphicsSystem::reloadTile(lua_State * luaState)
{
	lua_getglobal(luaState, "GraphicsSystem");
	GraphicsSystem* ptr = (GraphicsSystem*)lua_touserdata(luaState, -1);
	int index = lua_tointeger(luaState, -3);
	int tile = lua_tointeger(luaState, -2);

	if (index + 2 > 1 && index < ptr->tileMap.size() - 2)
	{ 
		ptr->tileMap.at(index + 2) = tile;
	}

	return 0;
}

int GraphicsSystem::newtexture(lua_State* luaState)
{
	lua_getglobal(luaState, "GraphicsSystem");
	GraphicsSystem* ptr = (GraphicsSystem*)lua_touserdata(luaState, -1);
	const char* filePath = lua_tostring(luaState, -2);
	lua_pop(luaState, 1);
	int* id = (int*)lua_newuserdata(luaState, sizeof(int*));
	
	ptr->textures.push_back(Texture2D());
	ptr->textures.back().loadFromFile(filePath);
	*id = ptr->textures.size() - 1;

	return 1;
}

int GraphicsSystem::settexture(lua_State * luaState)
{
	lua_getglobal(luaState, "GraphicsSystem");
	GraphicsSystem* ptr = (GraphicsSystem*)lua_touserdata(luaState, -1);
	
	int* texture_index = (int*)lua_touserdata(luaState, -2);
	int* id = (int*)lua_touserdata(luaState, -3);

	ptr->sprites[*id].setTexture(&ptr->textures[*texture_index]);

	return 0;
}

int GraphicsSystem::newsprite(lua_State* luaState)
{
	lua_getglobal(luaState, "GraphicsSystem");
	GraphicsSystem* ptr = (GraphicsSystem*)lua_touserdata(luaState, -1);
	int* texture = (int*)lua_touserdata(luaState, -2);
	int* normalMap = (int*)lua_touserdata(luaState, -3);
	int y = lua_tointeger(luaState, -4);
	int x = lua_tointeger(luaState, -5);
	
	y = y ? y : 48;
	x = x ? x : 48;

	lua_pop(luaState, 1);
	int* id = (int*)lua_newuserdata(luaState, sizeof(int*));
	ptr->sprites.push_back(Sprite());
	
	if (normalMap)
	{
		ptr->sprites.back().load(&ptr->shaders.amazing, &ptr->textures[*texture],
			&ptr->textures[*normalMap], glm::vec2(x, y));
	}
	else
	{	
		ptr->sprites.back().load(&ptr->shaders.basic, &ptr->textures[*texture],
				nullptr, glm::vec2(x, y));
	}
	
	*id = ptr->sprites.size() - 1;
	return 1;
}

int GraphicsSystem::newLight(lua_State* luaState)
{
	lua_getglobal(luaState, "GraphicsSystem");
	GraphicsSystem* ptr = (GraphicsSystem*)lua_touserdata(luaState, -1);
	int* texture = (int*)lua_touserdata(luaState, -2);
	int* normalMap = (int*)lua_touserdata(luaState, -3);
	int y = lua_tointeger(luaState, -4);
	int x = lua_tointeger(luaState, -5);
	float blue = lua_tonumber(luaState, -6);
	float green = lua_tonumber(luaState, -7);
	float red = lua_tonumber(luaState, -8);

	lua_pop(luaState, 1);
	int* id = (int*)lua_newuserdata(luaState, sizeof(int*));
	ptr->sprites.push_back(Sprite());

	if (normalMap)
	{	
		ptr->sprites.back().load(&ptr->shaders.amazing, &ptr->textures[*texture],
			&ptr->textures[*normalMap], glm::vec2(48, 48));
		
		ptr->lights.positions[ptr->numLights] = glm::vec3(x, y, 0);
		ptr->lights.colors[ptr->numLights++] = glm::vec4(red, green, blue, 1);
		
		ptr->sprites.back().posX = x;
		ptr->sprites.back().posY = y;
	}
	else
	{
		ptr->sprites.back().load(&ptr->shaders.basic, &ptr->textures[*texture],
				nullptr, glm::vec2(48, 48));

		ptr->lights.positions[ptr->numLights] = glm::vec3(x, y, 0);
		ptr->lights.colors[ptr->numLights++] = glm::vec4(red, green, blue, 1);
		
		ptr->sprites.back().posX = x;
		ptr->sprites.back().posY = y;
	}

	*id = ptr->sprites.size() - 1;
	return 1;
}

int GraphicsSystem::spritesize(lua_State* luaState)
{
	lua_getglobal(luaState, "GraphicsSystem");
	GraphicsSystem* ptr = (GraphicsSystem*)lua_touserdata(luaState, -1);
	float sizeY = lua_tonumber(luaState, -2);
	float sizeX = lua_tonumber(luaState, -3);
	int* id = (int*)lua_touserdata(luaState, -4);

	ptr->sprites[*id].setSize(sizeX, sizeY);

	return 0;
}

int GraphicsSystem::spritepos(lua_State* luaState)
{
	lua_getglobal(luaState, "GraphicsSystem");
	GraphicsSystem* ptr = (GraphicsSystem*)lua_touserdata(luaState, -1);	
	float y = lua_tonumber(luaState, -2);
	float x = lua_tonumber(luaState, -3);
	int* id = (int*)lua_touserdata(luaState, -4);

	ptr->sprites[*id].posX = x;
	ptr->sprites[*id].posY = y;
	
	return 0;
}

int GraphicsSystem::setspriterect(lua_State* luaState)
{
	lua_getglobal(luaState, "GraphicsSystem");
	GraphicsSystem* ptr = (GraphicsSystem*)lua_touserdata(luaState, -1);
	int height = lua_tointeger(luaState, -2);
	int width = lua_tointeger(luaState, -3);
	int y = lua_tointeger(luaState, -4);
	int x = lua_tointeger(luaState, -5);
	int* id = (int*)lua_touserdata(luaState, -6);

	ptr->sprites[*id].setTextureRect(x, height, width, y);

	return 0;
}

int GraphicsSystem::newtiletexture(lua_State* luaState)
{
	lua_getglobal(luaState, "GraphicsSystem");
	GraphicsSystem* ptr = (GraphicsSystem*)lua_touserdata(luaState, -1);
	const char* filePath2 = lua_tostring(luaState, -2);
	const char* filePath1 = lua_tostring(luaState, -3);
	lua_pop(luaState, 1);

	ptr->tileTextures.push_back(Texture2D());
	ptr->tileTextures.back().loadFromFile(filePath1);

	ptr->tileTextures.push_back(Texture2D());
	ptr->tileTextures.back().loadFromFile(filePath2);

	ptr->tiles.push_back(Sprite());
	ptr->tiles.back().load(&ptr->shaders.amazing, &ptr->tileTextures[ptr->tileTextures.size()-2], &ptr->tileTextures[ptr->tileTextures.size() - 1]);

	return 0;
}

int GraphicsSystem::clearTileMap(lua_State* luaState)
{
	lua_getglobal(luaState, "GraphicsSystem");
	GraphicsSystem* ptr = (GraphicsSystem*)lua_touserdata(luaState, -1);
	lua_pop(luaState, 1);

	ptr->tileTextures.clear();
	ptr->tileMap.clear();
	return 0;
}

int GraphicsSystem::newbackground(lua_State* luaState)
{
	lua_getglobal(luaState, "GraphicsSystem");
	GraphicsSystem* ptr = (GraphicsSystem*)lua_touserdata(luaState, -1);
	int* texture = (int*)lua_touserdata(luaState, -2);
	int* normalMap = (int*)lua_touserdata(luaState, -3);
	int y = lua_tointeger(luaState, -4);
	int x = lua_tointeger(luaState, -5);

	y = y ? y : 48;
	x = x ? x : 48;

	lua_pop(luaState, 1);
	int* id = (int*)lua_newuserdata(luaState, sizeof(int*));

	Sprite temp;
	ptr->backgrounds.push_back(temp);
	ptr->backgrounds.back().load(&ptr->shaders.trash, &ptr->textures[*texture],
			nullptr, glm::vec2(x, y));

	//*id = ptr->sprites.size() - 1;
	return 1;
}

int GraphicsSystem::backgroundpos(lua_State* luaState)
{
	lua_getglobal(luaState, "GraphicsSystem");
	GraphicsSystem* ptr = (GraphicsSystem*)lua_touserdata(luaState, -1);
	int i = lua_tonumber(luaState, -2);
	float y = lua_tonumber(luaState, -3);
	float x = lua_tonumber(luaState, -4);
	int* id = (int*)lua_touserdata(luaState, -5);

	//ptr->background.posX = x;
	//ptr->background.posY = y;

	ptr->backgrounds[i - 1].posX = x;
	ptr->backgrounds[i - 1].posY = y;

	return 0;
}

int GraphicsSystem::laseron(lua_State* luaState)
{
	lua_getglobal(luaState, "GraphicsSystem");
	GraphicsSystem* ptr = (GraphicsSystem*)lua_touserdata(luaState, -1);
	ptr->drawLaser = true;

	return 0;
}

int GraphicsSystem::laseroff(lua_State* luaState)
{
	lua_getglobal(luaState, "GraphicsSystem");
	GraphicsSystem* ptr = (GraphicsSystem*)lua_touserdata(luaState, -1);
	ptr->drawLaser = false;
	
	return 0;
}

int GraphicsSystem::flashon(lua_State* luaState)
{
	lua_getglobal(luaState, "GraphicsSystem");
	GraphicsSystem* ptr = (GraphicsSystem*)lua_touserdata(luaState, -1);
	ptr->postProcessor->flash = true;
	
	return 0;
}

int GraphicsSystem::flashoff(lua_State* luaState)
{
	lua_getglobal(luaState, "GraphicsSystem");
	GraphicsSystem* ptr = (GraphicsSystem*)lua_touserdata(luaState, -1);
	ptr->postProcessor->flash = false;

	return 0;
}


int GraphicsSystem::shakeon(lua_State* luaState)
{
	lua_getglobal(luaState, "GraphicsSystem");
	GraphicsSystem* ptr = (GraphicsSystem*)lua_touserdata(luaState, -1);
	ptr->postProcessor->shake = true;

	return 0;
}

int GraphicsSystem::shakeoff(lua_State* luaState)
{
	lua_getglobal(luaState, "GraphicsSystem");
	GraphicsSystem* ptr = (GraphicsSystem*)lua_touserdata(luaState, -1);
	ptr->postProcessor->shake = false;

	return 0;
}

int GraphicsSystem::lowhealthon(lua_State* luaState)
{
	lua_getglobal(luaState, "GraphicsSystem");
	GraphicsSystem* ptr = (GraphicsSystem*)lua_touserdata(luaState, -1);
	ptr->postProcessor->lowHealth = true;

	return 0;
}

int GraphicsSystem::lowhealthoff(lua_State* luaState)
{
	lua_getglobal(luaState, "GraphicsSystem");
	GraphicsSystem* ptr = (GraphicsSystem*)lua_touserdata(luaState, -1);
	ptr->postProcessor->lowHealth = false;

	return 0;
}