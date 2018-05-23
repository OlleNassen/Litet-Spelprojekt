#pragma once
#include"Shader.hpp"
#include "texture_2d.hpp"
#include "sprite.hpp"
#include "../GameEngine/game.hpp"
#include "billboard.hpp"
#include "mouse_effect.hpp"
#include "text.hpp"

#include<vector>
#include<glm/gtc/matrix_transform.hpp>
#include<glm/gtc/type_ptr.hpp>

#include<SFML/System/Vector2.hpp>

#include"particle_emitter.hpp"

#include "post_processor.hpp"


#define NUM_LIGHTS 10 + 1 // pixie in back

struct lua_State;
class Shader;
class Texture2D;
class Sprite;
class Camera;

struct PointLights
{
	//bool status; //On or off
	glm::vec3 positions[NUM_LIGHTS];
	glm::vec4 colors[NUM_LIGHTS];
	
};

class GraphicsSystem
{
private:
	Camera* camera;
	lua_State* luaState;
	std::vector<int> tileMap;
	std::vector<bool> visibleTiles; // For shadows
	std::vector<Texture2D> tileTextures;
	std::vector<Sprite> tiles;
	std::vector<Sprite> backgrounds;
	//Sprite background;
	int numLights = 1;

	ParticleEmitter* laserEffect;
	Billboard* billboards;
	MouseEffect* mouseEffect;
	PostProcessor* postProcessor;

	ShaderStruct& shaders;
	std::vector<Texture2D> textures;
	std::vector<Sprite> sprites;
	PointLights lights;

	bool drawLaser;

	//Text stuff:
	sf::Clock textClock;
	Text* currentLevel;

	Text* highscore;

public:
	GraphicsSystem(ShaderStruct& shad);
	~GraphicsSystem();

	void draw(
		float deltaTime, const glm::mat4& view,
		const glm::mat4& projection, int level);

	void drawLevelText(const glm::mat4& projection, int level);

	void addCamera(Camera* cam);

	void update(float deltaTime);

	void addLuaFunctions(lua_State* luaState);
	sf::Vector2f getPlayerPos() const;
	sf::Vector2f getPixie() const;

	void setHighScore(const std::string& highscore)
private:
	void drawSprites(const glm::mat4& view, const glm::mat4& projection);
	void drawTiles(const glm::mat4& view, const glm::mat4& projection);

	void displayHighscore();

	void updateCamera();
	
	static int loadTileMap(lua_State* luaState);
	static int reloadTile(lua_State* luaState);

	static int newtexture(lua_State* luaState);
	static int settexture(lua_State* luaState);
	static int newsprite(lua_State* luaState);
	static int newLight(lua_State* luaState);
	static int spritesize(lua_State* luaState);
	static int spritepos(lua_State* luaState);
	static int setspriterect(lua_State* luaState);

	static int newtiletexture(lua_State* luaState);

	static int clearTileMap(lua_State* luaState);
	static int newbackground(lua_State* luaState);
	static int backgroundpos(lua_State* luaState);

	static int laseron(lua_State* luaState);
	static int laseroff(lua_State* luaState);

	static int flashon(lua_State* luaState);
	static int flashoff(lua_State* luaState);

	static int shakeon(lua_State* luaState);
	static int shakeoff(lua_State* luaState);
};

