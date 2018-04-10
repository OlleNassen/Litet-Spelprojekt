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

	sprites.push_back(new Sprite(textures[0], shaders[0]));


	for (int i = 0; i < 100; i++)
		tiles.push_back(new Sprite(textures[1], shaders[0]));


}

GraphicsSystem::~GraphicsSystem()
{
	for (auto& sprite : sprites)
	{
		delete sprite;
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

	textures[0]->bind();

	shaders.back()->use();

	sprites[0]->drawPlayer(luaVector->back());
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
		textures[1]->bind();

		shaders[0]->use();

		if (tileMap[i] != 0)
			tile->drawTile(glm::vec2(x, y));

		i++;
	}

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
}

void GraphicsSystem::loadShaders()
{
	shaders.push_back(new Shader("Resources/Shaders/VertexShaderCore.glsl", "Resources/Shaders/FragmentShaderCore.glsl"));
}

/*
int newSprite(lua_State* luaState)
{
lua_getglobal(luaState, "CollisionSystem");
CollisionSystem* ptr = (CollisionSystem*)lua_touserdata(luaState, -1);
lua_pop(luaState, 1);
int* id = (int*)lua_newuserdata(luaState, sizeof(int));
*id = ptr->addPosition();

return 1;
}

int getposition(lua_State* luaState)
{
lua_getglobal(luaState, "CollisionSystem");
CollisionSystem* ptr = (CollisionSystem*)lua_touserdata(luaState, -1);
int id = lua_tointeger(luaState, -2);
lua_pop(luaState, 1);

sf::Vector2f pos = ptr->getWantedPosition(id);
lua_pushnumber(luaState, pos.y);
lua_pushnumber(luaState, pos.x);

return 2;
}

int setposition(lua_State* luaState)
{
lua_getglobal(luaState, "CollisionSystem");
CollisionSystem* ptr = (CollisionSystem*)lua_touserdata(luaState, -1);
float y = lua_tonumber(luaState, -2);
float x = lua_tonumber(luaState, -3);
int id = lua_tointeger(luaState, -4);

ptr->setWantedPosition(id, x, y);

lua_pop(luaState, 1);

return 0;
}


static const struct luaL_Reg positionlib[] =
{
{ "new", newposition },
{ "getPosition", getposition },
{ "setPosition", setposition },
{ "move", moveposition },
{ NULL, NULL }
};
*/