#pragma once
#include"Shader.hpp"
#include "texture_2d.hpp"
#include "sprite.hpp"

#include<vector>
#include<glm/gtc/matrix_transform.hpp>
#include<glm/gtc/type_ptr.hpp>

#include<SFML/System/Vector2.hpp>

#include"particle_emitter.hpp"

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
	ParticleEmitter* emitter;

public:
	GraphicsSystem();
	~GraphicsSystem();

	void drawSprites(const glm::mat4& view, const glm::mat4& projection);
	void drawTiles(const glm::mat4& view, const glm::mat4& projection);

	void addLuaFunctions(lua_State* luaState);
	sf::Vector2f getPlayerPos() const;
	sf::Vector2f getPixie() const;

	void drawline_mod(int map[20][20], int x, int y, int x2, int y2) {
		int dx = abs(x - x2);
		int dy = abs(y - y2);
		double s = double(.99 / (dx>dy ? dx : dy));
		double t = 0.0;
		while (t < 1.0) {
			dx = int((1.0 - t)*x + t * x2);
			dy = int((1.0 - t)*y + t * y2);
			if (map[dy][dx] != 1) {
				map[dy][dx] = 5;
			}
			else {
				return;
			}
			t += s;
		}
	}


	void los(int map[20][20], int range, int plx, int ply) {
		int x, y;
		for (double f = 0; f < 3.14 * 2; f += 0.05) {
			x = int(range*cos(f)) + plx;
			y = int(range*sin(f)) + ply;
			drawline_mod(map, plx, ply, x, y);
		}
	}


private:
	void loadShaders();
	
	static int loadTileMap(lua_State* luaState);
	static int reloadTile(lua_State* luaState);

	static int newtexture(lua_State* luaState);
	static int newsprite(lua_State* luaState);
	static int spritepos(lua_State* luaState);

	static int newtiletexture(lua_State* luaState);

	static int clearTileMap(lua_State* luaState);
	static int newbackground(lua_State* luaState);
	static int backgroundpos(lua_State* luaState);
};

