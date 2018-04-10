#include "CollisionSystem.hpp"
#include "CollisionSystem.hpp"
#include <iostream>

int newposition(lua_State* luaState)
{
	lua_getglobal(luaState, "CollisionSystem");
	CollisionSystem* ptr = (CollisionSystem*)lua_touserdata(luaState, -1);
	lua_pop(luaState, 1);
	int* id = (int*)lua_newuserdata(luaState, sizeof(int*));
	*id = ptr->addPosition();
	
	return 1;
}

int getposition(lua_State* luaState)
{	
	lua_getglobal(luaState, "CollisionSystem");
	CollisionSystem* ptr = (CollisionSystem*)lua_touserdata(luaState, -1);
	int* id = (int*)lua_touserdata(luaState, -2);
	lua_pop(luaState, 1);
	
	sf::Vector2f pos = ptr->getWantedPosition(*id);
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
	int* id = (int*)lua_touserdata(luaState, -4);

	ptr->setWantedPosition(*id, x, y);

	lua_pop(luaState, 1);
	
	return 0;
}

int moveposition(lua_State* luaState)
{
	lua_getglobal(luaState, "CollisionSystem");
	CollisionSystem* ptr = (CollisionSystem*)lua_touserdata(luaState, -1);
	float y = lua_tonumber(luaState, -2);
	float x = lua_tonumber(luaState, -3);
	int* id = (int*)lua_touserdata(luaState, -4);

	sf::Vector2f pos = ptr->getWantedPosition(*id);
	ptr->setWantedPosition(*id, pos.x + x, pos.y + y);

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

CollisionSystem::CollisionSystem()
{
	width = 10;
	height = 10;

	positionCurrent = 0;
	positionCount = 10;

	tileSize = 48;
	
	//tileList = new unsigned int[width * height];

	tileList = a;



}

CollisionSystem::~CollisionSystem()
{
	delete tileList;
}

void CollisionSystem::addLuaPosition(lua_State* luaState)
{
	lua_pushlightuserdata(luaState, this);
	lua_setglobal(luaState, "CollisionSystem");
	
	luaL_openlib(luaState, "position", positionlib, 0);
}

int CollisionSystem::addPosition()
{
	positions.push_back(sf::Vector2f());
	positions.push_back(sf::Vector2f());
	positionCurrent += 2;
	return positionCurrent - 2;
}

sf::Vector2f& CollisionSystem::getWantedPosition(int id)
{
	return positions[id];
}
void CollisionSystem::setWantedPosition(int id, float x, float y)
{
	positions[id] = sf::Vector2f(x, y);
}

void CollisionSystem::update(float deltaTime)
{
	for (unsigned int id = 0; id < positions.size(); id += 2)
	{
		int x;
		int y;
			
		x = positions[id].x / tileSize;
		y = positions[id + 1].y / tileSize;

		if (tileList[x + y * width] == 0 && tileList[(x + 1) + (y + 1) * width] == 0)
		{
			positions[id + 1].x = positions[id].x;
		}

		x = positions[id + 1].x / tileSize;
		y = positions[id].y / tileSize;

		if (tileList[x + y * width] == 0 && tileList[(x + 1) + (y + 1) * width] == 0)
		{
			positions[id + 1].y = positions[id].y;
		}
		
		x = positions[id].x / tileSize;
		y = positions[id].y / tileSize;
		
		if (tileList[x + y * width] == 0 && tileList[(x+1) + (y+1) * width] == 0)
		{
			positions[id + 1] = positions[id];
		}
		else
		{
			positions[id] = positions[id + 1];
		}
	}
}