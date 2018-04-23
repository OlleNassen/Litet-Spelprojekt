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
	sf::Music music;
	
	std::vector<sf::SoundBuffer> soundBuffers;
	std::vector<sf::Sound> sounds;

	static int newMusic(lua_State* luaState);

	static int newSoundBuffer(lua_State* luaState);
	static int newSound(lua_State* luaState);
	static int playSound(lua_State* luaState);
};

