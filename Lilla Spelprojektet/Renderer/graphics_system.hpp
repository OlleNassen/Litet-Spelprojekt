#pragma once
#include"Shader.hpp"
#include "texture_2d.hpp"
#include "sprite.hpp"

#include<vector>
#include<glm/gtc/matrix_transform.hpp>
#include<glm/gtc/type_ptr.hpp>

#include<SFML/System/Vector2.hpp>

#include"particle_emitter.hpp"

#define NUM_LIGHTS 10 + 1 // pixie in back

struct lua_State;
class Shader;
class Texture2D;
class Sprite;

struct PointLights
{
	//bool status; //On or off
	glm::vec3 positions[NUM_LIGHTS];
	glm::vec4 colors[NUM_LIGHTS];
	
};

class GraphicsSystem
{
private:
	lua_State * luaState;
	std::vector<int> tileMap;
	std::vector<bool> visibleTiles; // For shadows
	std::vector<Texture2D*> tileTextures;
	std::vector<Sprite*> tiles;
	Sprite* background;
	int numLights = 1;

	//For black sidething
	Texture2D* blackFridayTexture;
	Sprite* blackFridaySprite;

	std::vector<Shader*> shaders;
	std::vector<Texture2D*> textures;
	std::vector<Sprite*> sprites;
	PointLights* lights;
	ParticleEmitter* emitter;

	//Shadow temp
	float tempX;
	float tempY;
	float lastT = -1;

public:
	GraphicsSystem();
	~GraphicsSystem();

	void drawSprites(const glm::mat4& view, const glm::mat4& projection);
	void drawTiles(const glm::mat4& view, const glm::mat4& projection);

	void addLuaFunctions(lua_State* luaState);
	sf::Vector2f getPlayerPos() const;
	sf::Vector2f getPixie() const;

	//Shadow temp
	// Returns 1 if the lines intersect, otherwise 0. In addition, if the lines 
	// intersect the intersection point may be stored in the floats i_x and i_y.
	bool get_line_intersection(float p0_x, float p0_y, float p1_x, float p1_y,
		float p2_x, float p2_y, float p3_x, float p3_y)
	{
		float s1_x, s1_y, s2_x, s2_y;
		s1_x = p1_x - p0_x;     s1_y = p1_y - p0_y;
		s2_x = p3_x - p2_x;     s2_y = p3_y - p2_y;

		float s, t;
		s = (-s1_y * (p0_x - p2_x) + s1_x * (p0_y - p2_y)) / (-s2_x * s1_y + s1_x * s2_y);
		t = (s2_x * (p0_y - p2_y) - s2_y * (p0_x - p2_x)) / (-s2_x * s1_y + s1_x * s2_y);

		if (s >= 0 && s <= 1 && t >= 0 && t <= 1)
		{
			// Collision detected

			if (lastT == -1 || t < lastT)
			{
				tempY = p0_x + (t * s1_x);
				tempX = p0_y + (t * s1_y);
			}

			return true;
		}

		return false; // No collision
	}


private:
	void loadShaders();
	void initShadows();
	
	static int loadTileMap(lua_State* luaState);
	static int reloadTile(lua_State* luaState);

	static int newtexture(lua_State* luaState);
	static int newsprite(lua_State* luaState);
	static int newLight(lua_State* luaState);
	static int spritepos(lua_State* luaState);

	static int newtiletexture(lua_State* luaState);

	static int clearTileMap(lua_State* luaState);
	static int newbackground(lua_State* luaState);
	static int backgroundpos(lua_State* luaState);
};

