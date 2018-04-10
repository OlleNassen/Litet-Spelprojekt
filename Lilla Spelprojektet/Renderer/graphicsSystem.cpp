#include "graphicsSystem.hpp"
#define BUFFER_OFFSET(i) ((char *)nullptr + (i))


static unsigned int a[] =
{
	1,1,1,1,1,1,1,1,1,1,
	1,0,0,0,0,0,0,0,0,1,
	1,0,0,0,0,0,0,0,0,1,
	1,0,0,0,0,0,0,0,0,1,
	1,0,0,0,0,0,0,0,0,1,
	1,0,0,0,0,0,0,0,0,1,
	1,0,0,0,0,0,0,0,0,1,
	1,0,0,0,0,0,0,0,0,1,
	1,0,0,0,0,0,0,0,0,1,
	1,1,1,1,1,1,1,1,1,1
};

GraphicsSystem::GraphicsSystem(std::vector<lua_State*>* luaStateVector)
{
	tileMap = a;
	addVector(luaStateVector);

	loadShaders();
	loadTextures();

	players.push_back(new Sprite(textures[0], shaders[0]));

	goombas.push_back(new Sprite(textures[3], shaders[0]));
	


	for (int i = 0; i < 100; i++)
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

void GraphicsSystem::drawPlayer(const glm::mat4& view, const glm::mat4& projection)
{

	shaders.back()->setInt(0, "image");
	shaders.back()->setMatrix4fv(view, "view");
	shaders.back()->setMatrix4fv(projection, "projection");

	shaders.back()->use();

	players[0]->draw(this->getPlayerPosition(luaVector->back()));
}

void GraphicsSystem::drawTiles(const glm::mat4& view, const glm::mat4& projection)
{
	int i = 0;
	
	for (auto& tile : tiles)
	{
		float x = (i % 10) * 48;
		float y = (i / 10) * 48;

		shaders.back()->setInt(0, "image");
		shaders.back()->setMatrix4fv(view, "view");
		shaders.back()->setMatrix4fv(projection, "projection");

		shaders[0]->use();

		if (tileMap[i] != 0)
			tile->draw(glm::vec2(x, y));

		i++;
	}

}

void GraphicsSystem::drawBossman(const glm::mat4 & view, const glm::mat4 & projection)
{
	shaders.back()->setInt(0, "image");
	shaders.back()->setMatrix4fv(view, "view");
	shaders.back()->setMatrix4fv(projection, "projection");

	//Select texture here:
	

	shaders.back()->use();

	

	//Draw here:

}

void GraphicsSystem::drawGoombas(const glm::mat4 & view, const glm::mat4 & projection)
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
	lua_getglobal(luaState, "getBossPosition");
	if (lua_isfunction(luaState, -1))
	{
		lua_pcall(luaState, 0, 2, 0);
		position.x = lua_tonumber(luaState, -1);
		position.y = lua_tonumber(luaState, -2);
		lua_pop(luaState, 2);
	}
	else std::cout << "getBossPosition is not a function" << std::endl;

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
