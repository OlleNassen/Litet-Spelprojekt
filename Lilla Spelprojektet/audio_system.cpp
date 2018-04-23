#include "audio_system.hpp"



AudioSystem::AudioSystem()
{

}


AudioSystem::~AudioSystem()
{

}

void AudioSystem::addLuaFunctions(lua_State* luaState)
{
	lua_pushlightuserdata(luaState, this);
	lua_setglobal(luaState, "AudioSystem");

	lua_pushcfunction(luaState, newMusic);
	lua_setglobal(luaState, "newMusic");

	lua_pushcfunction(luaState, newSoundBuffer);
	lua_setglobal(luaState, "newSoundBuffer");

	lua_pushcfunction(luaState, newSound);
	lua_setglobal(luaState, "newSound");

	lua_pushcfunction(luaState, playSound);
	lua_setglobal(luaState, "playSound");
}

int AudioSystem::newMusic(lua_State* luaState)
{
	lua_getglobal(luaState, "AudioSystem");
	AudioSystem* ptr = (AudioSystem*)lua_touserdata(luaState, -1);
	const char* filePath = lua_tostring(luaState, -2);
	lua_pop(luaState, 1);
	int* id = (int*)lua_newuserdata(luaState, sizeof(int*));

	ptr->music.openFromFile(filePath);
	ptr->music.play();
	*id = 1;

	return 1;
}

int AudioSystem::newSoundBuffer(lua_State* luaState)
{
	lua_getglobal(luaState, "AudioSystem");
	AudioSystem* ptr = (AudioSystem*)lua_touserdata(luaState, -1);
	const char* filePath = lua_tostring(luaState, -2);
	lua_pop(luaState, 1);
	int* id = (int*)lua_newuserdata(luaState, sizeof(int*));

	ptr->soundBuffers.push_back(sf::SoundBuffer());
	ptr->soundBuffers.back().loadFromFile(filePath);
	*id = ptr->soundBuffers.size() - 1;

	return 1;
}

int AudioSystem::newSound(lua_State* luaState)
{
	lua_getglobal(luaState, "AudioSystem");
	AudioSystem* ptr = (AudioSystem*)lua_touserdata(luaState, -1);
	int* soundBuffer = (int*)lua_touserdata(luaState, -2);
	int* id = (int*)lua_newuserdata(luaState, sizeof(int*));

	ptr->sounds.push_back(sf::Sound());
	ptr->sounds.back().setBuffer(ptr->soundBuffers[*soundBuffer]);

	*id = ptr->sounds.size() - 1;
	return 1;
}

int AudioSystem::playSound(lua_State* luaState)
{
	lua_getglobal(luaState, "AudioSystem");
	AudioSystem* ptr = (AudioSystem*)lua_touserdata(luaState, -1);
	int* id = (int*)lua_touserdata(luaState, -2);

	ptr->sounds[*id].play();

	return 0;
}