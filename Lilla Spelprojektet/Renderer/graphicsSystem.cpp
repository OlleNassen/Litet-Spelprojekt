#include "graphicsSystem.hpp"
#define BUFFER_OFFSET(i) ((char *)nullptr + (i))

GraphicsSystem::GraphicsSystem(std::vector<lua_State*>* luaStateVector)
{
	addVector(luaStateVector);

	loadShaders();
	textures.push_back(new Texture2D("Resources/Sprites/donaldtrump.png"));
	tiles.push_back(new Sprite(textures[0], shaders[0]));
	tiles.push_back(new Sprite(textures[0], shaders[0]));
}

GraphicsSystem::~GraphicsSystem()
{
	for (auto& tile : tiles)
	{
		delete tile;
	}

	for (auto& player : players)
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

void GraphicsSystem::drawSprites(glm::mat4& view, const glm::mat4& projection)
{
	for (int i = 0; i < players.size(); i++)
	{
		shaders.back()->setInt(0, "image");
		shaders.back()->setMatrix4fv(view, "view");
		shaders.back()->setMatrix4fv(projection, "projection");

		glm::vec2 position;
		position.x = players[i]->posX;
		position.y = players[i]->posY;

		players[i]->draw(position);
	}	
}

void GraphicsSystem::drawTiles(glm::mat4& view, const glm::mat4& projection)
{	
	for (int i = 0; i < tileMap.size() - 2; i++)
	{
		float x = (i % tileMap[0]) * 48;
		float y = (i / tileMap[0]) * 48;

		shaders.back()->setInt(0, "image");
		shaders.back()->setMatrix4fv(view, "view");
		shaders.back()->setMatrix4fv(projection, "projection");

		shaders[0]->use();

		if (tileMap[i + 2] != 0)
			tiles[tileMap[i + 2]]->draw(glm::vec2(x, y));

	}

}

void GraphicsSystem::addLuaFunctions(lua_State* luaState)
{
	lua_pushlightuserdata(luaState, this);
	lua_setglobal(luaState, "GraphicsSystem");

	lua_pushcfunction(luaState, loadTileMap);
	lua_setglobal(luaState, "loadTileGraphics");

	lua_pushcfunction(luaState, newtexture);
	lua_setglobal(luaState, "newTexture");

	lua_pushcfunction(luaState, newsprite);
	lua_setglobal(luaState, "newSprite");

	lua_pushcfunction(luaState, spritepos);
	lua_setglobal(luaState, "spritePos");
}

void GraphicsSystem::addVector(std::vector<lua_State*>* vector)
{
	luaVector = vector;
}

void GraphicsSystem::loadShaders()
{
	shaders.push_back(new Shader("Resources/Shaders/VertexShaderCore.glsl", "Resources/Shaders/FragmentShaderCore.glsl"));
}

sf::Vector2f GraphicsSystem::getPlayerPos() const
{
	return sf::Vector2f(players[0]->posX, players[0]->posY);
}

int GraphicsSystem::loadTileMap(lua_State * luaState)
{
	lua_getglobal(luaState, "GraphicsSystem");
	GraphicsSystem* ptr = (GraphicsSystem*)lua_touserdata(luaState, -1);
	ptr->tileMap.push_back(lua_tointeger(luaState, -2));

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
	lua_pop(luaState, 1);
	int* id = (int*)lua_newuserdata(luaState, sizeof(int*));

	ptr->players.push_back(new Sprite(ptr->textures[*texture], ptr->shaders[0]));
	*id = ptr->players.size() - 1;
	return 1;
}

int GraphicsSystem::spritepos(lua_State* luaState)
{
	lua_getglobal(luaState, "GraphicsSystem");
	GraphicsSystem* ptr = (GraphicsSystem*)lua_touserdata(luaState, -1);	
	float y = lua_tonumber(luaState, -2);
	float x = lua_tonumber(luaState, -3);
	int* id = (int*)lua_touserdata(luaState, -4);

	ptr->players[*id]->posX = x;
	ptr->players[*id]->posY = y;
	
	return 0;
}

