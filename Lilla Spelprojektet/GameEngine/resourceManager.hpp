#pragma once
#include <vector>
#include "..\Renderer\spriteRenderer.hpp"

class ResourceManager
{
private:
	//std::vector<2DTexture> gameTextures;
	std::vector<SpriteRenderer> menuTextures;

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