#pragma once
#include <vector>

class ResourceManager
{
private:
	//std::vector<2DTexture> gameTextures;
	//std::vector<2DTexture> menuTextures;

	//std::vector<audioFiles>gameAudio;
	//std::vector<audioFile>menuAudio;
public:
	//Todo: Implement
	//ResourceManager(LOAD GAME RESOURCES);
	//ResourceManager(LOAD MENU RESOURCES);
	~ResourceManager();
private:
	void loadGameResources();
	void loadMenuResources();

};