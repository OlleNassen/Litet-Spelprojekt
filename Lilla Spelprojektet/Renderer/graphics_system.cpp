#include "graphics_system.hpp"
#define BUFFER_OFFSET(i) ((char *)nullptr + (i))

GraphicsSystem::GraphicsSystem(std::vector<lua_State*>* luaStateVector)
{
	addVector(luaStateVector);

	loadShaders();

	textures.push_back(new Texture2D("Resources/Sprites/background2.png"));

	background = new Sprite(shaders[0], textures[0], nullptr, glm::vec2(WIDTH, HEIGHT));
}

GraphicsSystem::~GraphicsSystem()
{
	for (auto& tile : tiles)
	{
		delete tile;
	}

	for (auto& player : sprites[sprites.size() - 1])
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
	if (sprites.size() > 0 && sprites[sprites.size() - 1].size() > 0)
	{
		for (auto& sprite : sprites[sprites.size() - 1])
		{
			glm::vec2 Resolution{ 1280,720 };
			glm::vec3 LightPos{ getPlayerPos().x + (48 / 2), getPlayerPos().y - 48.f, 0.075f };
			glm::vec3 Falloff{ .4f, 3.f, 20.f };
			glm::vec4 LightColor{ 1.f, 0.8f, 0.6f, 1.f };
			glm::vec4 AmbientColor{ 0.6f, 0.6f, 1.f, 0.2f };

			shaders[2]->setVector3f(LightPos, "LightPos");
			shaders[2]->setVector4f(LightColor, "LightColor");
			shaders[2]->setVector4f(AmbientColor, "AmbientColor");

			glm::vec2 position;
			position.x = sprite->posX;
			position.y = sprite->posY;

			sprite->draw(position, view, projection);
		}
	}

}

void GraphicsSystem::drawTiles(const glm::mat4& view, const glm::mat4& projection)
{	
	sf::Vector2f vec = getPlayerPos();
	
	background->draw(glm::vec2(vec.x - (WIDTH/2), vec.y - (HEIGHT / 2)), view, projection);
	
	if (tileMap.size() > 0)
	{
		for (int i = 0; i < tileMap.size() - 2; i++)
		{
			float x = (i % tileMap[0]) * 48;
			float y = (i / tileMap[0]) * 48;

			if (tileMap[i + 2] != 0)
				tiles[tileMap[i + 2]]->draw(glm::vec2(x, y), view, projection);

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
}

void GraphicsSystem::pushSpriteVector()
{
 	sprites.push_back(std::vector<Sprite*>());
}
void GraphicsSystem::popSpriteVector()
{
	for (auto& player : sprites[sprites.size() - 1])
	{
		delete player;
	}
	sprites.pop_back();

	tileMap.clear();
}

void GraphicsSystem::addVector(std::vector<lua_State*>* vector)
{
	luaVector = vector;
}

void GraphicsSystem::loadShaders()
{
	shaders.push_back(new Shader("Resources/Shaders/basicShader.vert", "Resources/Shaders/basicShader.frag"));
	shaders.push_back(new Shader("Resources/Shaders/normalShader.vert", "Resources/Shaders/normalShader.frag"));
	shaders.push_back(new Shader("Resources/Shaders/2d_shader.vert", "Resources/Shaders/2d_shader.frag"));
}

sf::Vector2f GraphicsSystem::getPlayerPos() const
{
	sf::Vector2f vec(0, 0);

	if (sprites[sprites.size() - 1].size() > 0)
	{
		vec = sf::Vector2f(sprites[sprites.size() - 1][0]->posX, sprites[sprites.size() - 1][0]->posY);
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

	ptr->sprites[ptr->sprites.size() - 1].push_back(new Sprite(ptr->shaders[2], ptr->textures[*texture], normalMap ? ptr->textures[*normalMap] : nullptr, glm::vec2(x, y)));
	*id = ptr->sprites[ptr->sprites.size() - 1].size() - 1;
	return 1;
}

int GraphicsSystem::spritepos(lua_State* luaState)
{
	lua_getglobal(luaState, "GraphicsSystem");
	GraphicsSystem* ptr = (GraphicsSystem*)lua_touserdata(luaState, -1);	
	float y = lua_tonumber(luaState, -2);
	float x = lua_tonumber(luaState, -3);
	int* id = (int*)lua_touserdata(luaState, -4);

	ptr->sprites[ptr->sprites.size() - 1][*id]->posX = x;
	ptr->sprites[ptr->sprites.size() - 1][*id]->posY = y;
	
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

