#include "resourceManager.hpp"

ResourceManager::ResourceManager()
{
	menuTextures.push_back(new Texture2D("Resources/Sprites/HansTap.png"));
}

ResourceManager::~ResourceManager()
{
	for (auto& texture : menuTextures)
	{
		delete texture;
	}
}

Texture2D* ResourceManager::getTexture(std::string nameOfTexture)
{
	return menuTextures.back();
}
