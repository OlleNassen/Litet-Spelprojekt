#include "resourceManager.hpp"

ResourceManager::ResourceManager()
{
	menuTextures.push_back(new Texture2D("Resources/Sprites/HansTap.png"));
	shaders.push_back(new Shader("Resources/Shaders/VertexShaderCore.glsl", "Resources/Shaders/FragmentShaderCore.glsl"));
}

ResourceManager::~ResourceManager()
{
	for (auto& texture : menuTextures)
	{
		delete texture;
	}
	for (auto& shader : shaders)
	{
		delete shader;
	}
}

Texture2D* ResourceManager::getTexture(std::string textureName)
{
	//Temp
	return menuTextures.back();
}

Shader* ResourceManager::getShader(std::string shaderName)
{
	//Temp
	return shaders.back();
}
