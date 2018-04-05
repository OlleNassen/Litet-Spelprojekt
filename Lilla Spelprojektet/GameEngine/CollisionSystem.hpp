#ifndef COLLISIONSYSTEM_HPP
#define COLLISIONSYSTEM_HPP
#include <SFML/System/Vector2.hpp>
#include <lua.hpp>
#include <vector>

int luaopen_position(lua_State* luaState);

class CollisionSystem
{
public:	
	CollisionSystem();
	virtual ~CollisionSystem();

	int addPosition();

	sf::Vector2f& getWantedPosition(int id);
	void setWantedPosition(int id, float x, float y);

	void update(float deltaTime);

private:
	unsigned int* tileList;
	std::vector<sf::Vector2f> positions;

	unsigned int width;
	unsigned int height;

	unsigned int positionCurrent;
	unsigned int positionCount;

	int tileSize;
};

#endif // COLLISIONSYSTEM_HPP

