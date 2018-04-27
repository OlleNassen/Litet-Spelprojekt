#include "graphics_system.hpp"
#include"Shader.hpp"
#include "texture_2d.hpp"
#include "sprite.hpp"
#include <lua.hpp>
#include <SFML\Window.hpp> // TEMP FOR SHADOWS
#define BUFFER_OFFSET(i) ((char *)nullptr + (i))

#define WIDTH 1280
#define HEIGHT 720

GraphicsSystem::GraphicsSystem()
{
	loadShaders();

	textures.push_back(new Texture2D("Resources/Sprites/brick_diffuse.png"));
	textures.push_back(new Texture2D("Resources/Sprites/brick_normal.png"));
	textures.push_back(new Texture2D("Resources/Sprites/starParticle_diffuse.png"));
	textures.push_back(new Texture2D("Resources/Sprites/starParticle_normal.png"));

	background = new Sprite(shaders[2], textures[0], textures[1], glm::vec2(WIDTH, HEIGHT));

	emitter = new ParticleEmitter(
		shaders[2], 
		textures[2], 
		textures[3],
		glm::vec2(20.f, 20.f), 
		glm::vec2(1800.f, 2000.f), 
		10.f);

	lights = new PointLights;
	
	for (int i = 1; i < NUM_LIGHTS; i++)
	{
		lights->positions[i] = glm::vec3(-10000, -10000, 0);
		lights->colors[i] = glm::vec4(0, 0, 0, 0);
	}
	
	blackFridayTexture = new Texture2D("Resources/Sprites/background2.png");
	blackFridaySprite = new Sprite(shaders[0], blackFridayTexture, nullptr);
}

GraphicsSystem::~GraphicsSystem()
{
	//delete lights;

	for (auto& tile : tiles)
	{
		delete tile;
	}

	for (auto& player : sprites)
	{
		delete player;
	}

	for (auto& texture : textures)
	{
		delete texture;
	}

	for (auto& shader : shaders)
	{
		delete shader;
	}

	delete this->emitter;
}

void GraphicsSystem::drawSprites(const glm::mat4& view, const glm::mat4& projection)
{	
	if (sprites.size() > 0)
	{
		for (int itr = sprites.size() - 1; itr >= 0; itr--)
		{
			glm::vec3 lightP{ getPixie().x + 24.f, getPixie().y + 24.f, 0.075f };
			glm::vec4 lightC{ 0.8f, 0.2f, 0.1f, 0.f };

			lights->positions[0] = lightP;
			lights->colors[0] = lightC;

			shaders[2]->use();
			glUniform3fv(glGetUniformLocation(shaders[2]->getID(), "lightPos"), NUM_LIGHTS, &lights->positions[0][0]);
			glUniform4fv(glGetUniformLocation(shaders[2]->getID(), "lightColor"), NUM_LIGHTS, &lights->colors[0][0]);
			shaders[2]->unuse();

			glm::vec2 position;
			position.x = sprites[itr]->posX;
			position.y = sprites[itr]->posY;


			shaders[2]->setVector3f(glm::vec3(1, 0, 0), "status");

			sprites[itr]->draw(position, view, projection);
		}
	}

	emitter->push(1, this->sprites[0]->posX + 24.f, this->sprites[0]->posY + 48.f);
	emitter->update(0.0016f);
	emitter->render(view, projection, 0.0016f);
}

void GraphicsSystem::drawTiles(const glm::mat4& view, const glm::mat4& projection)
{		
	background->draw(glm::vec2(background->posX, background->posY), view, projection);

	if (tileMap.size() > 0)
	{
		//Temp
		if (sf::Keyboard::isKeyPressed(sf::Keyboard::Key::BackSpace))
		{
			initShadows();
		}

		for (int y = (getPlayerPos().y - HEIGHT/2) / 48 - 1; y < (getPlayerPos().y + HEIGHT/2) / 48; y++)
		{
			for (int x = (getPlayerPos().x - WIDTH/2) / 48 - 1; x < (getPlayerPos().x + WIDTH/2) / 48; x++)
			{
				if (x >= 0 && y >= 0 && x < tileMap[0] && y < tileMap[1] 
					&& tileMap[x + 2 + y * tileMap[0]] != 0)
				{
					glm::vec3 lightP{ getPixie().x + 24.f, getPixie().y + 24.f, 0.075f };
					glm::vec4 lightC{ 0.8f, 0.2f, 0.1f, 0.f };


					lights->positions[0] = lightP;
					lights->colors[0] = lightC;

					shaders[2]->use();
					glUniform3fv(glGetUniformLocation(shaders[2]->getID(), "lightPos"), NUM_LIGHTS, &lights->positions[0][0]);
					glUniform4fv(glGetUniformLocation(shaders[2]->getID(), "lightColor"), NUM_LIGHTS, &lights->colors[0][0]);
					shaders[2]->unuse();

					if (visibleTiles[x + 2 + y * tileMap[0]])
					{
						shaders[2]->setVector3f(glm::vec3(1, 0, 0), "status");
					}
					else
					{
						shaders[2]->setVector3f(glm::vec3(0, 0, 0), "status");
					}

					tiles[tileMap[x + 2 + y * tileMap[0]]]->draw(glm::vec2(x * 48, y * 48), view, projection);
				}
				else if (x < 0 || y < 0 || x >= tileMap[0] || y >= tileMap[1])
				{
					blackFridaySprite->draw(glm::vec2(x * 48, y * 48), view, projection);
				}
			}
		}
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
}

void GraphicsSystem::loadShaders()
{
	shaders.push_back(new Shader("Resources/Shaders/basicShader.vert", "Resources/Shaders/basicShader.frag"));
	shaders.push_back(new Shader("Resources/Shaders/2d_shader.vert", "Resources/Shaders/2d_shader.frag"));
	shaders.push_back(new Shader("Resources/Shaders/amazing_shader.vert", "Resources/Shaders/amazing_shader.frag"));
}

void GraphicsSystem::initShadows()
{
	for (int i = 0; i < visibleTiles.size(); i++)
	{
		visibleTiles[i] = false;
	}

	for (int numLights = 0; numLights < NUM_LIGHTS - 1; numLights++)
		for (int i = 0; i<360; i++)
		{
			float t = 10000;
			int tilePtr = -1;

			float dirX = cos((float)i*0.01745f);
			float dirY = sin((float)i*0.01745f);

			float range = 1000.f;

			glm::vec2 rayDir{ dirX, dirY };

			rayDir = glm::vec2(lights->positions[numLights]) + rayDir * range;

			for (int y = (getPlayerPos().y - HEIGHT) / 48; y < (getPlayerPos().y + HEIGHT) / 48; y++)
			{
				for (int x = (getPlayerPos().x - WIDTH) / 48; x < (getPlayerPos().x + WIDTH) / 48; x++)
				{
					if (x >= 0 && y >= 0 && x < tileMap[0] && y < tileMap[1]
						&& tileMap[x + 2 + y * tileMap[0]] != 0)
					{

						int left = x * 48;
						int top = y * 48;
						int right = x * 48 + 48;
						int bottom = y * 48 + 48;

						if (get_line_intersection(lights->positions[numLights].x, lights->positions[numLights].y, rayDir.x, rayDir.y, left, top, right, top) ||
							get_line_intersection(lights->positions[numLights].x, lights->positions[numLights].y, rayDir.x, rayDir.y, left, top, left, bottom) ||
							get_line_intersection(lights->positions[numLights].x, lights->positions[numLights].y, rayDir.x, rayDir.y, right, bottom, right, top) ||
							get_line_intersection(lights->positions[numLights].x, lights->positions[numLights].y, rayDir.x, rayDir.y, right, bottom, left, bottom))
						{
							float value = glm::length(glm::vec2(lights->positions[numLights].x, lights->positions[numLights].y) - glm::vec2(tempX, tempY));
							if (t > value)
							{
								t = value;
								tilePtr = x + 2 + y * tileMap[0];
							}

							lastT = -1;
						}

					}
				}
			}

			if (tilePtr != -1)
			{
				visibleTiles[tilePtr] = true;
			}

		}
}

sf::Vector2f GraphicsSystem::getPlayerPos() const
{
	sf::Vector2f vec(0, 0);

	if (sprites.size() > 0)
	{
		vec = sf::Vector2f(sprites[0]->posX, sprites[0]->posY);
	}
	
	return vec;
}

sf::Vector2f GraphicsSystem::getPixie() const
{
	sf::Vector2f vec(0, 0);

	if (sprites.size() > 0)
	{
		vec = sf::Vector2f(sprites[1]->posX, sprites[1]->posY);
	}

	return vec;
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
	
	ptr->textures.push_back(new Texture2D(filePath));
	*id = ptr->textures.size() - 1;

	return 1;
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
	
	if (normalMap)
	{
		ptr->sprites.push_back(
			new Sprite(ptr->shaders[2], ptr->textures[*texture], 
				ptr->textures[*normalMap], glm::vec2(x, y)));
	}
	else
	{
		ptr->sprites.push_back(
			new Sprite(ptr->shaders[0], ptr->textures[*texture], 
				nullptr, glm::vec2(x, y)));
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

	if (normalMap)
	{
		ptr->sprites.push_back(
			new Sprite(ptr->shaders[2], ptr->textures[*texture],
				ptr->textures[*normalMap], glm::vec2(48, 48)));
		ptr->lights->positions[ptr->numLights] = glm::vec3(x, y, 0);
		ptr->lights->colors[ptr->numLights++] = glm::vec4(red, green, blue, 1);
		ptr->sprites.back()->posX = x;
		ptr->sprites.back()->posY = y;
	}
	else
	{
		ptr->sprites.push_back(
			new Sprite(ptr->shaders[0], ptr->textures[*texture],
				nullptr, glm::vec2(48, 48)));

		ptr->lights->positions[ptr->numLights] = glm::vec3(x, y, 0);
		ptr->lights->colors[ptr->numLights++] = glm::vec4(red, green, blue, 1);
		ptr->sprites.back()->posX = x;
		ptr->sprites.back()->posY = y;
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

	ptr->sprites[*id]->setSize(sizeX, sizeY);

	return 0;
}

int GraphicsSystem::spritepos(lua_State* luaState)
{
	lua_getglobal(luaState, "GraphicsSystem");
	GraphicsSystem* ptr = (GraphicsSystem*)lua_touserdata(luaState, -1);	
	float y = lua_tonumber(luaState, -2);
	float x = lua_tonumber(luaState, -3);
	int* id = (int*)lua_touserdata(luaState, -4);

	ptr->sprites[*id]->posX = x;
	ptr->sprites[*id]->posY = y;
	
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

	ptr->sprites[*id]->setTextureRect(x, height, width, y);

	return 0;
}

int GraphicsSystem::newtiletexture(lua_State* luaState)
{
	lua_getglobal(luaState, "GraphicsSystem");
	GraphicsSystem* ptr = (GraphicsSystem*)lua_touserdata(luaState, -1);
	const char* filePath2 = lua_tostring(luaState, -2);
	const char* filePath1 = lua_tostring(luaState, -3);
	lua_pop(luaState, 1);

	ptr->tileTextures.push_back(new Texture2D(filePath1));
	ptr->tileTextures.push_back(new Texture2D(filePath2));
	ptr->tiles.push_back(new Sprite(ptr->shaders[2], ptr->tileTextures[ptr->tileTextures.size()-2], ptr->tileTextures[ptr->tileTextures.size() - 1]));

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

	if (normalMap)
	{
		ptr->background = 
			new Sprite(ptr->shaders[2], ptr->textures[*texture],
				ptr->textures[*normalMap], glm::vec2(x, y));
	}
	else
	{
		ptr->background = 
			new Sprite(ptr->shaders[0], ptr->textures[*texture],
				nullptr, glm::vec2(x, y));
	}

	//*id = ptr->sprites.size() - 1;
	return 1;
}

int GraphicsSystem::backgroundpos(lua_State* luaState)
{
	lua_getglobal(luaState, "GraphicsSystem");
	GraphicsSystem* ptr = (GraphicsSystem*)lua_touserdata(luaState, -1);
	float y = lua_tonumber(luaState, -2);
	float x = lua_tonumber(luaState, -3);
	int* id = (int*)lua_touserdata(luaState, -4);

	ptr->background->posX = x;
	ptr->background->posY = y;

	return 0;
}