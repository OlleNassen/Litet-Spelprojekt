#ifndef EVENTSYSTEM_HPP
#define EVENTSYSTEM_HPP

#include <SFML/Window/Event.hpp>
#include <lua.hpp>
#include <vector>

/** Class for handling events, converting them to game inputs 
and sending them to the current lua state*/
class EventSystem
{
public:	
	EventSystem();
	virtual ~EventSystem();

	/** Adds vector of lua states */
	void addVector(std::vector<lua_State*>* vector);
	
	/** Adds function 'bool rebind("input", isOpposite)' to lua state */
	void addLuaRebind(lua_State* luaState); 
	
	 /* Set the current event */
	void setEvent(sf::Event newEvent);
	
	/** Called every tick */
	void update(float deltaTime); 

private:
	/** Temporary lua state */
	lua_State* luaState; 
	
	std::vector<lua_State*>* luaVector;
		
	/** Returns if specific asxis is move above threshold */
	float getAxisPosition(unsigned int joystick, sf::Joystick::Axis axis) const; 	
	/** Update the mousePosition */
	void updateMouse();
	
	 /** Current mouse position */
	sf::Vector2i mousePosition;
};

#endif // EVENTSYSTEM_HPP

