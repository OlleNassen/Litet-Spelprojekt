#include "graphics_system.hpp"
#include"Shader.hpp"
#include "texture_2d.hpp"
#include "sprite.hpp"
#include <lua.hpp>
#define BUFFER_OFFSET(i) ((char *)nullptr + (i))

#define WIDTH 1280
#define HEIGHT 720

GraphicsSystem::GraphicsSystem(lua_State* luaState)
{
	loadShaders();

	textures.push_back(new Texture2D("Resources/Sprites/brick_diffuse.png"));
	textures.push_back(new Texture2D("Resources/Sprites/brick_normal.png"));


	background = new Sprite(shaders[1], textures[0], textures[1], glm::vec2(WIDTH, HEIGHT));
}

GraphicsSystem::~GraphicsSystem()
{
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
}

void GraphicsSystem::drawSprites(const glm::mat4& view, const glm::mat4& projection)
{
	if (sprites.size() > 0)
	{
		for (int itr = sprites.size() - 1; itr >= 0; itr--)
		{
			//glm::vec3 lightPos{ getPlayerPos().x + (48 / 2), getPlayerPos().y - 48.f, 0.075f };
			glm::vec3 lightPos{ getPixie().x + 24.f, getPixie().y + 24.f, 0.075f };

			//glm::vec3 lightPos{ WIDTH, 0, 0.075f };

			glm::vec4 lightColor{ 0.2f, 0.2f, 0.8f, 0.f };

			shaders[1]->setVector3f(lightPos, "lightPos");
			shaders[1]->setVector4f(lightColor, "lightColor");

			glm::vec2 position;
			position.x = sprites[itr]->posX;
			position.y = sprites[itr]->posY;

			sprites[itr]->draw(position, view, projection);
		}
	}

}

void GraphicsSystem::drawTiles(const glm::mat4& view, const glm::mat4& projection)
{	
	sf::Vector2f vec = getPlayerPos();
	
	background->draw(glm::vec2(vec.x - (WIDTH/2), vec.y - (HEIGHT / 2)), view, projection);	

	if (tileMap.size() > 0)
	{
		for (int y = (getPlayerPos().y - HEIGHT) / 48; y < (getPlayerPos().y + HEIGHT) / 48; y++)
		{
			for (int x = (getPlayerPos().x - WIDTH) / 48; x < (getPlayerPos().x + WIDTH) / 48; x++)
			{
				if (x >= 0 && y >= 0 && x < tileMap[0] && y < tileMap[1] 
					&& tileMap[x + 2 + y * tileMap[0]] != 0)
				{
					tiles[tileMap[x + 2 + y * tileMap[0]]]->draw(glm::vec2(x * 48, y * 48), view, projection);
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

	lua_pushcfunction(luaState, spritepos);
	lua_setglobal(luaState, "spritePos");

	lua_pushcfunction(luaState, newtiletexture);
	lua_setglobal(luaState, "tileTexture");

	lua_pushcfunction(luaState, clearTileMap);
	lua_setglobal(luaState, "clearTileMap");
}

void GraphicsSystem::loadShaders()
{
	shaders.push_back(new Shader("Resources/Shaders/basicShader.vert", "Resources/Shaders/basicShader.frag"));
	shaders.push_back(new Shader("Resources/Shaders/2d_shader.vert", "Resources/Shaders/2d_shader.frag"));
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
			new Sprite(ptr->shaders[1], ptr->textures[*texture], 
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

int GraphicsSystem::newtiletexture(lua_State* luaState)
{
	lua_getglobal(luaState, "GraphicsSystem");
	GraphicsSystem* ptr = (GraphicsSystem*)lua_touserdata(luaState, -1);
	const char* filePath2 = lua_tostring(luaState, -2);
	const char* filePath1 = lua_tostring(luaState, -3);
	lua_pop(luaState, 1);

	ptr->tileTextures.push_back(new Texture2D(filePath1));
	ptr->tileTextures.push_back(new Texture2D(filePath2));
	ptr->tiles.push_back(new Sprite(ptr->shaders[1], ptr->tileTextures[ptr->tileTextures.size()-2], ptr->tileTextures[ptr->tileTextures.size() - 1]));

	return 0;
}

int GraphicsSystem::clearTileMap(lua_State* luaState)
{
	lua_getglobal(luaState, "GraphicsSystem");
	GraphicsSystem* ptr = (GraphicsSystem*)lua_touserdata(luaState, -1);
	lua_pop(luaState, 1);

	//ptr->tileTextures.clear();
	ptr->tileMap.clear();
	return 0;
}

