#include "resourceManager.hpp"

ResourceManager::ResourceManager()
{
	//** Menu textures */
	menuTextures.push_back(new Texture2D("Resources/Sprites/HansTap.png"));

	//** Game textures */


	//** Shaders*/
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

Texture2D* ResourceManager::getTexture(const std::string& textureName)
{
	//Temp
	if (textureName == "HansTap.png")
	{
		return menuTextures[0];
	}

	else
		return nullptr;

}

Shader* ResourceManager::getShader(const std::string& shaderName)
{
	//Temp
	return shaders.back();
}
