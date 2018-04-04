#include "CollisionSystem.hpp"
#include "CollisionSystem.hpp"
#include <iostream>

int newposition(lua_State* luaState)
{
	lua_getglobal(luaState, "CollisionSystem");
	CollisionSystem* ptr = (CollisionSystem*)lua_touserdata(luaState, -1);
	lua_pop(luaState, 1);
	int* id = (int*)lua_newuserdata(luaState, sizeof(int));
	*id = ptr->addVector();

	return 1;
}

int getposition(lua_State* luaState)
{
	std::cout << "funkar!!!" << std::endl;
	
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

int moveposition(lua_State* luaState)
{
	lua_getglobal(luaState, "CollisionSystem");
	CollisionSystem* ptr = (CollisionSystem*)lua_touserdata(luaState, -1);
	float y = lua_tonumber(luaState, -2);
	float x = lua_tonumber(luaState, -3);
	int id = lua_tointeger(luaState, -4);

	sf::Vector2f pos = ptr->getWantedPosition(id);
	ptr->setWantedPosition(id, x - pos.x, y - pos.y);

	lua_pop(luaState, 1);
	
	return 0;
}

static const struct luaL_reg positionlib_f[] = 
{
	{ "new", newposition },
	{ NULL, NULL }
};

static const struct luaL_reg positionlib_m[] = 
{
	{ "getPosition", getposition },
	{ "setPosition", setposition },
	{ "move", moveposition },
	{ NULL, NULL }
};

int luaopen_position(lua_State* luaState)
{
	luaL_newmetatable(luaState, "CollisionSystem.position");

	lua_pushstring(luaState, "__index");
	lua_pushvalue(luaState, -2);  /* pushes the metatable */
	lua_settable(luaState, -3);  /* metatable.__index = metatable */

	luaL_openlib(luaState, NULL, positionlib_m, 0);
	luaL_openlib(luaState, "position", positionlib_f, 0);

	return 1;
}

void CollisionSystem::draw(sf::RenderWindow& window)
{
	for (unsigned int i = 0; i < width * height; i++)
	{
		if(tileList[i] != 0)
		{
			sf::RectangleShape rect;
			rect.setSize(sf::Vector2f(1280 / 10, 720 / 10));
			rect.setFillColor(sf::Color::Red);
			rect.setPosition((i % width) * 64, (i / height) * 64);
			window.draw(rect);
		}

	}
}

CollisionSystem::CollisionSystem()
{
	width = 10;
	height = 10;

	positionCurrent = 0;
	positionCount = 10;

	tileSize = 64;
	
	tileList = new unsigned int[width * height];
	wantedPosition = new sf::Vector2f[positionCount];
	currentPosition = new sf::Vector2f[positionCount];

	for (unsigned int i = 0; i < width * height; i++)
	{
		tileList[i] = 0;
	}
	for (unsigned int i = 85; i < 100; i++)
	{
		tileList[i] = 1;
	}
}

CollisionSystem::~CollisionSystem()
{
	delete currentPosition;
	delete wantedPosition;
	delete tileList;
}

int CollisionSystem::addVector()
{
	return positionCurrent++;
}

sf::Vector2f& CollisionSystem::getWantedPosition(int id) const
{
	return wantedPosition[id];
}
void CollisionSystem::setWantedPosition(int id, float x, float y)
{
	wantedPosition[id] = sf::Vector2f(x, y);
}

void CollisionSystem::update(float deltaTime)
{
	for (unsigned int id = 0; id < 1; id++)
	{
		int x;
		int y;
			
		x = wantedPosition[id].x / tileSize;
		y = currentPosition[id].y / tileSize;

		if (tileList[x + y * width] == 0 && tileList[(x + 1) + (y + 1) * width] == 0)
		{
			currentPosition[id].x = wantedPosition[id].x;
		}

		x = currentPosition[id].x / tileSize;
		y = wantedPosition[id].y / tileSize;

		if (tileList[x + y * width] == 0 && tileList[(x + 1) + (y + 1) * width] == 0)
		{
			currentPosition[id].y = wantedPosition[id].y;
		}
		
		x = wantedPosition[id].x / tileSize;
		y = wantedPosition[id].y / tileSize;
		
		if (tileList[x + y * width] == 0 && tileList[(x+1) + (y+1) * width] == 0)
		{
			currentPosition[id] = wantedPosition[id];
		}
		else
		{
			wantedPosition[id] = currentPosition[id];
		}
	}
}