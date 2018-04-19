#pragma once
#include"Shader.hpp"
#include "texture_2d.hpp"
#include "sprite.hpp"

#include<vector>
#include<glm/gtc/matrix_transform.hpp>
#include<glm/gtc/type_ptr.hpp>

#include<SFML/System/Vector2.hpp>

struct lua_State;
class Shader;
class Texture2D;
class Sprite;

struct PointLight
{
	bool status; //On or off
	glm::vec3 position;
	glm::vec3 lightColor;
};

class GraphicsSystem
{
private:
	lua_State * luaState;
	std::vector<int> tileMap;
	std::vector<Texture2D*> tileTextures;
	std::vector<Sprite*> tiles;
	Sprite* background;

	std::vector<Shader*> shaders;
	std::vector<Texture2D*> textures;
	std::vector<Sprite*> sprites;
	std::vector<PointLight*>lights;

public:
	GraphicsSystem(lua_State* luaState);
	~GraphicsSystem();

	void drawSprites(const glm::mat4& view, const glm::mat4& projection);
	void drawTiles(const glm::mat4& view, const glm::mat4& projection);

	void addLuaFunctions(lua_State* luaState);
	sf::Vector2f getPlayerPos() const;
	sf::Vector2f getPixie() const;
	/*
	void FOV()
	{
		float x, y;
		int i;
		CLEAR_MAP_TO_NOT_VISIBLE();//Initially set all tiles to not visible.
		for (i = 0; i<360; i++)
		{
			x = cos((float)i*0.01745f);
			y = sin((float)i*0.01745f);
			DoFov(x, y);
		};
	};

	void DoFov(float x, float y)
	{
		int i;
		float ox, oy;
		ox = (float)PLAYERX + 0.5f;
		oy = (float)PLAYERY + 0.5f;
		for (i = 0; i<VIEW_RADIUS; i++)
		{
			MAP[(int)ox][(int)oy] = VISIBLE;//Set the tile to visible.
			if (MAP[(int)ox][(int)oy] == BLOCK)
				return;
			ox += x;
			oy += y;
		};
	};
	*/

	float VIEW_RADIUS = 100.f;

	void DoFov(float x, float y)
	{

	};

private:
	void loadShaders();
	
	static int loadTileMap(lua_State* luaState);
	static int reloadTile(lua_State* luaState);

	static int newtexture(lua_State* luaState);
	static int newsprite(lua_State* luaState);
	static int spritepos(lua_State* luaState);

	static int newtiletexture(lua_State* luaState);

	static int clearTileMap(lua_State* luaState);
};

