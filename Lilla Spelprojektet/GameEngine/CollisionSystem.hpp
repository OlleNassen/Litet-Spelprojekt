#ifndef COLLISIONSYSTEM_HPP
#define COLLISIONSYSTEM_HPP
#include <SFML/System/Vector2.hpp>
#include <SFML/Graphics.hpp>
#include <lua.hpp>

int luaopen_position(lua_State* luaState);

class CollisionSystem
{
public:
	void draw(sf::RenderWindow& window);
	
	CollisionSystem();
	virtual ~CollisionSystem();

	int addVector();

	sf::Vector2f& getWantedPosition(int id) const;
	void setWantedPosition(int id, float x, float y);

	void update(float deltaTime);

private:
	unsigned int* tileList;
	sf::Vector2f* wantedPosition;
	sf::Vector2f* currentPosition;

	unsigned int width;
	unsigned int height;

	unsigned int positionCurrent;
	unsigned int positionCount;

	int tileSize;
};

#endif // COLLISIONSYSTEM_HPP

