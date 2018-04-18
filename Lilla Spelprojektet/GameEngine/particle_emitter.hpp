#pragma once

#include<vector>
#include<glm/gtc/matrix_transform.hpp>
#include<glm/gtc/type_ptr.hpp>

class Shader;
class Texture2D;
class Sprite;

class ParticleEmitter
{
private:
	std::vector<glm::vec2> particle_positions;
	std::vector<float> particle_lifetime;
	Sprite* particle;

	//Private functions

public:
	//Con & Des
	ParticleEmitter(
		Shader* shader, 
		Texture2D* texture, 
		Texture2D* normalMap = nullptr, 
		const glm::vec2& size = glm::vec2(10, 10));

	virtual ~ParticleEmitter();

	//Functions
	void update();
	void render(const glm::mat4& view, const glm::mat4& projection);

	//Accessors

	//Modifiers

};

