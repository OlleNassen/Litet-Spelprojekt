#include "graphicsSystem.hpp"
#define BUFFER_OFFSET(i) ((char *)nullptr + (i))

GraphicsSystem::GraphicsSystem(std::vector<lua_State*>* luaStateVector)
{
	addVector(luaStateVector);

	loadShaders();
	loadTextures();

	players.push_back(new Sprite(textures[0], shaders[0]));

	goombas.push_back(new Sprite(textures[3], shaders[0]));
	

	tiles.push_back(new Sprite(textures[2], shaders[0]));
	tiles.push_back(new Sprite(textures[2], shaders[0]));


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
	for (auto& goomba : goombas)
	{
		delete goomba;
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

void GraphicsSystem::drawPlayer(glm::mat4& view, const glm::mat4& projection)
{

	shaders.back()->setInt(0, "image");
	shaders.back()->setMatrix4fv(view, "view");
	shaders.back()->setMatrix4fv(projection, "projection");

	shaders.back()->use();

	players[0]->draw(this->getPlayerPosition(luaVector->back()));
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

void GraphicsSystem::drawBossman(glm::mat4 & view, const glm::mat4 & projection)
{
	shaders.back()->setInt(0, "image");
	shaders.back()->setMatrix4fv(view, "view");
	shaders.back()->setMatrix4fv(projection, "projection");

	//Select texture here:
	textures[1]->bind();

	shaders.back()->use();

	//Draw here:

	goombas[0]->draw(getBossPosition(luaVector->back()));
}

void GraphicsSystem::drawGoombas(glm::mat4 & view, const glm::mat4 & projection)
{
	shaders.back()->setInt(0, "image");
	shaders.back()->setMatrix4fv(view, "view");
	shaders.back()->setMatrix4fv(projection, "projection");

	//Select texture here:
	textures[1]->bind();

	shaders.back()->use();

	//Draw here:

	//std::cout << getGoombaPosition(luaVector->back()).x << " " << getGoombaPosition(luaVector->back()).y << "\n";

	goombas[0]->draw(getGoombaPosition(luaVector->back()));
}

void GraphicsSystem::addLuaFunctions(lua_State* luaState)
{
	lua_pushlightuserdata(luaState, this);
	lua_setglobal(luaState, "GraphicsSystem");

	lua_pushcfunction(luaState, loadTileMap);
	lua_setglobal(luaState, "loadTileGraphics");
}

void GraphicsSystem::addVector(std::vector<lua_State*>* vector)
{
	luaVector = vector;
}

void GraphicsSystem::loadTextures()
{
	textures.push_back(new Texture2D("Resources/Sprites/HansTap.png"));
	textures.push_back(new Texture2D("Resources/Sprites/prototype.png"));
	textures.push_back(new Texture2D("Resources/Sprites/donaldtrump.png"));
	textures.push_back(new Texture2D("Resources/Sprites/goomba.png"));

}

void GraphicsSystem::loadShaders()
{
	shaders.push_back(new Shader("Resources/Shaders/VertexShaderCore.glsl", "Resources/Shaders/FragmentShaderCore.glsl"));
}

glm::vec2 GraphicsSystem::getPlayerPosition(lua_State* luaState) const
{
	glm::vec2 position;
	lua_getglobal(luaState, "playerPosition");
	if (lua_isfunction(luaState, -1))
	{
		lua_pcall(luaState, 0, 2, 0);
		position.x = lua_tonumber(luaState, -1);
		position.y = lua_tonumber(luaState, -2);
		lua_pop(luaState, 2);
	}
	else std::cout << "playerPosition is not a function" << std::endl;

	return position;
}

glm::vec2 GraphicsSystem::getBossPosition(lua_State* luaState) const
{
	glm::vec2 position;
	lua_getglobal(luaState, "bossPosition");
	if (lua_isfunction(luaState, -1))
	{
		lua_pcall(luaState, 0, 2, 0);
		position.x = lua_tonumber(luaState, -1);
		position.y = lua_tonumber(luaState, -2);
		lua_pop(luaState, 2);
	}
	else std::cout << "bossPosition is not a function" << std::endl;

	return position;
}

glm::vec2 GraphicsSystem::getGoombaPosition(lua_State * luaState) const
{
	glm::vec2 position;
	lua_getglobal(luaState, "goombaPosition");
	if (lua_isfunction(luaState, -1))
	{
		lua_pcall(luaState, 0, 2, 0);
		position.x = lua_tonumber(luaState, -1);
		position.y = lua_tonumber(luaState, -2);
		lua_pop(luaState, 2);
	}
	else std::cout << "goombaPosition is not a function" << std::endl;

	return position;
}

int GraphicsSystem::loadTileMap(lua_State * luaState)
{
	lua_getglobal(luaState, "GraphicsSystem");
	GraphicsSystem* ptr = (GraphicsSystem*)lua_touserdata(luaState, -1);
	ptr->tileMap.push_back(lua_tointeger(luaState, -2));

	return 0;
}