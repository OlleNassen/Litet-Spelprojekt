#ifndef EVENTSYSTEM_HPP
#define EVENTSYSTEM_HPP

#include <SFML/Window/Event.hpp>
#include <lua.hpp>

/** Class for handling events, converting them to game inputs 
and sending them to the current lua state*/
class EventSystem
{
public:	
	EventSystem();
	virtual ~EventSystem();

	/** Adds function 'bool rebind("input", isOpposite)' to lua state */
	void addLuaRebind(lua_State* luaState); 
	
	 /* Set the current event */
	void setEvent(sf::Event newEvent);
	
	/** Called every tick */
	void update(float deltaTime); 

	/** Temporary lua state */
	lua_State* luaState; 

private: 
		
	/** Returns if specific asxis is move above threshold */
	float getAxisPosition(unsigned int joystick, sf::Joystick::Axis axis) const; 	
	/** Update the mousePosition */
	void updateMouse();
	
	 /** Current mouse position */
	sf::Vector2i mousePosition;
};

#endif // EVENTSYSTEM_HPP

