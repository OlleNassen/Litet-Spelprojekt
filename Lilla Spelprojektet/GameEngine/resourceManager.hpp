#pragma once
#include <vector>
#include "..\Renderer\spriteRenderer.hpp"

class ResourceManager
{
private:
	//std::vector<2DTexture> gameTextures;
	std::vector<Texture2D*> menuTextures;
	std::vector<Shader*> shaders;

	//std::vector<audioFiles>gameAudio;
	//std::vector<audioFile>menuAudio;
public:
	//Todo: Implement
	//ResourceManager(LOAD MENU RESOURCES);
	//ResourceManager(LOAD GAME RESOURCES);
	ResourceManager();
	~ResourceManager();

	Texture2D* getTexture(std::string nameOfTexture);
	Shader* getShader(std::string nameOfTexture);
private:
	void loadGameResources();
	void loadMenuResources();

};