#pragma once

#include <lua.hpp>
#include <SFML/Audio.hpp>

class AudioSystem
{
public:
	AudioSystem();
	~AudioSystem();

	void addLuaFunctions(lua_State* luaState);

private:	
	std::vector<sf::SoundBuffer> soundBuffers;
	std::vector<sf::Sound> sounds;

	static int newSoundBuffer(lua_State* luaState);
	static int newSound(lua_State* luaState);
	static int playSound(lua_State* luaState);
	static int stopSound(lua_State* luaState);
	static int pauseSound(lua_State* luaState);
};

