#include "event_system.hpp"
#include <lua.hpp>
#include "game.hpp"

#define REGISTER_ENUM(x) x,
/** Enum with all available inputs */
typedef enum
{
	#include "input.hpp"
	inputCount
} InputEnum;
#undef REGISTER_ENUM

#define REGISTER_ENUM(x) #x,
/** char array with all available inputs */
const char* InputText[] =
{
	#include "input.hpp"
	"invalid"
};
#undef REGISTER_ENUM

/** Input binds for mouse buttons */
sf::Mouse::Button mButtons[InputEnum::inputCount * 2] = { sf::Mouse::ButtonCount };
/** Input binds for keyboard keys */
sf::Keyboard::Key keys[InputEnum::inputCount * 2] = { sf::Keyboard::KeyCount };
/** Input binds for joystick buttons */
unsigned int jButtons[InputEnum::inputCount * 2] = { sf::Joystick::ButtonCount + 1 };
/** Input binds for joystick axis */
sf::Joystick::Axis jAxis[InputEnum::inputCount] = { (sf::Joystick::Axis)sf::Joystick::AxisCount };
/** If current input wants input repeated */
bool repeat[InputEnum::inputCount] = { true };

/** If current input wants input repeated */
bool wantRebind =  false;
unsigned int rebindId = InputEnum::inputCount * 2;

/** Ask for a rebind of a specific input (remapped later in event loop) */
int luaRebind(lua_State* luaState)
{
	bool result = false;
	
	int isOpposite = 1 + lua_toboolean(luaState, -1);
	const char* text = lua_tostring(luaState, -2);
	
	for (unsigned int id = 0; id < InputEnum::inputCount && !result; id++)
	{
		if (strcmp(text, InputText[id]) == 0)
		{
			wantRebind = true;
			rebindId = id * isOpposite;
			result = true;
		}		
	}

	lua_pop(luaState, 1);
	return 0;
}

int bindkeyboard(lua_State* luaState)
{
	bool result = false;

	int keyValueNeg = lua_tointeger(luaState, -1);
	int keyValuePos = lua_tointeger(luaState, -2);
	const char* text = lua_tostring(luaState, -3);

	for (unsigned int id = 0; id < InputEnum::inputCount && !result; id++)
	{
		if (strcmp(text, InputText[id]) == 0)
		{			
			keys[id] = (sf::Keyboard::Key)keyValuePos;
			keys[id + InputEnum::inputCount] = (sf::Keyboard::Key)keyValueNeg;
			result = true;
		}
	}

	lua_pop(luaState, 1);
	return 0;
}

int bindmouse(lua_State* luaState)
{
	bool result = false;

	int buttonValueNeg = lua_tointeger(luaState, -1);
	int buttonValuePos = lua_tointeger(luaState, -2);
	const char* text = lua_tostring(luaState, -3);

	for (unsigned int id = 0; id < InputEnum::inputCount && !result; id++)
	{
		if (strcmp(text, InputText[id]) == 0)
		{
			mButtons[id] = (sf::Mouse::Button)buttonValuePos;
			mButtons[id + InputEnum::inputCount] = (sf::Mouse::Button)buttonValueNeg;
			result = true;
		}
	}

	lua_pop(luaState, 1);
	return 0;
}

int bindjoystick(lua_State* luaState)
{
	bool result = false;

	int buttonValueNeg = lua_tointeger(luaState, -1);
	int buttonValuePos = lua_tointeger(luaState, -2);
	const char* text = lua_tostring(luaState, -3);

	for (unsigned int id = 0; id < InputEnum::inputCount && !result; id++)
	{
		if (strcmp(text, InputText[id]) == 0)
		{
			jButtons[id] = (unsigned int)buttonValuePos;
			jButtons[id + InputEnum::inputCount] = (unsigned int)buttonValueNeg;
			result = true;
		}
	}

	lua_pop(luaState, 1);
	return 0;
}

EventSystem::EventSystem()
{
	for (unsigned int id = 0; id < InputEnum::inputCount * 2; id++)
	{
		mButtons[id] = sf::Mouse::ButtonCount;
		keys[id] = sf::Keyboard::KeyCount;
		jButtons[id] = sf::Joystick::ButtonCount + 1;
		repeat[id] = true;
	}

	for (unsigned int id = 0; id < InputEnum::inputCount; id++)
	{
		jAxis[id] = (sf::Joystick::Axis)sf::Joystick::AxisCount;
		repeat[id] = true;
	}	
}

EventSystem::~EventSystem()
{
	
}

void EventSystem::addVector(std::vector<State>* vector)
{
	luaVector = vector;
}

void EventSystem::addLuaRebind(lua_State* luaState)
{
	lua_pushcfunction(luaState, luaRebind);
	lua_setglobal(luaState, "rebind");

	lua_pushcfunction(luaState, bindkeyboard);
	lua_setglobal(luaState, "bindKeyboard");

	lua_pushcfunction(luaState, bindmouse);
	lua_setglobal(luaState, "bindMouse");

	lua_pushcfunction(luaState, bindjoystick);
	lua_setglobal(luaState, "bindJoystick");
}

void EventSystem::setEvent(sf::Event currentEvent)
{
	if(wantRebind && currentEvent.key.code != sf::Keyboard::Q)
	{
		switch (currentEvent.type)
		{
		case sf::Event::MouseButtonPressed:
			mButtons[rebindId] = currentEvent.mouseButton.button;
			wantRebind = false;
			break;
		case sf::Event::KeyPressed:
			keys[rebindId] = currentEvent.key.code;
			wantRebind = false;
			break;
		case sf::Event::JoystickButtonPressed:
			jButtons[rebindId] = currentEvent.joystickButton.button;
			wantRebind = false;
			break;
		case sf::Event::JoystickMoved:
			unsigned int axisId = rebindId < InputEnum::inputCount ? rebindId : rebindId / 2;
			
			if (getAxisPosition(0, jAxis[axisId]))
			{
				jAxis[axisId] = currentEvent.joystickMove.axis;
				wantRebind = false;
			}
			break;
		}
	}
}

void EventSystem::update(float deltaTime)
{
	luaState = luaVector->back().luaState;
	
	for (unsigned int id = 0; id < InputEnum::inputCount; id++)
	{
		float direction = getAxisPosition(0, jAxis[id]);
		
		bool isPressed =
			sf::Mouse::isButtonPressed(mButtons[id]) ||
			sf::Keyboard::isKeyPressed(keys[id]) ||
			sf::Joystick::isButtonPressed(0, jButtons[id]) ||
			direction;

		direction = direction ? direction : isPressed ? 100.0f : -100.0f;
		
		isPressed = isPressed ||
			sf::Mouse::isButtonPressed(mButtons[id + InputEnum::inputCount]) ||
			sf::Keyboard::isKeyPressed(keys[id + InputEnum::inputCount]) ||
			sf::Joystick::isButtonPressed(0, jButtons[id + InputEnum::inputCount]);
		
		if (isPressed && repeat[id])
		{
			/* push functions and arguments */
			lua_getglobal(luaState, InputText[id]);  /* function to be called */
			lua_pushnumber(luaState, direction / 100.0f);   /* push 1st argument */
			lua_pushnumber(luaState, deltaTime);   /* push 2nd argument */
			lua_pcall(luaState, 2, 1, 0);

			repeat[id] = lua_toboolean(luaState, -1);
			lua_pop(luaState, 1);  /* pop returned value */
		}
		else if (!isPressed && !repeat[id])
		{
			repeat[id] = true;
		}
	}
	updateMouse();
}

float EventSystem::getAxisPosition(unsigned int joystick, sf::Joystick::Axis axis) const
{
	float result = sf::Joystick::getAxisPosition(joystick, axis);	
	return result > 20.0f || result < -20.0f ? result : 0.0f;
}

void EventSystem::updateMouse()
{
	sf::Vector2i newPosition = sf::Mouse::getPosition();	
	sf::Vector2i position = newPosition - mousePosition;
	mousePosition = newPosition;

	/* push functions and arguments */
	lua_getglobal(luaState, "mouse");
	lua_pushinteger(luaState, position.x);
	lua_pushinteger(luaState, position.y);
	lua_pcall(luaState, 2, 0, 0);
}