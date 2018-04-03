#include "menuState.hpp"
#include <glm\glm.hpp>

MenuState::MenuState()
{
	resources = new ResourceManager();
	renderer = new SpriteRenderer(*resources->getShader("temp"));
}

MenuState::~MenuState()
{
	delete this->renderer;
	delete this->resources;
}

void MenuState::handleInput()
{
	if (sf::Keyboard::isKeyPressed(sf::Keyboard::Left))
	{
		// this makes us go to the next state(game state from here)
		changeState = true;
	}

}

void MenuState::update()
{
}

void MenuState::draw() const
{
	//Fix this and put it somewhere else:
	/*
	glm::mat4 projection = glm::ortho(0.0f, static_cast<GLfloat>(this->Width),
		static_cast<GLfloat>(this->Height), 0.0f, -1.0f, 1.0f);
	ResourceManager::GetShader("sprite").Use().SetInteger("image", 0);
	ResourceManager::GetShader("sprite").SetMatrix4("projection", projection);
	*/
	renderer->drawSprite(*resources->getTexture("HansTap.png"),
		glm::vec2(200, 200), glm::vec2(300, 400), 45.0f, glm::vec3(0.0f, 1.0f, 0.0f));
}

void MenuState::pause()
{
}

void MenuState::resume()
{
}
