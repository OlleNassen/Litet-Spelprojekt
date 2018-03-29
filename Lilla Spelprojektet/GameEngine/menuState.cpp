#include "menuState.hpp"

MenuState::MenuState()
{
	resources = new ResourceManager();
	shader = new Shader("Resources/Shaders/VertexShaderCore.glsl", "Resources/Shaders/FragmentShaderCore.glsl");
	renderer = new SpriteRenderer(*shader);
}

MenuState::~MenuState()
{
}

void MenuState::handleInput()
{
	if (sf::Keyboard::isKeyPressed(sf::Keyboard::Left))
	{
		// left key is pressed: move our character
		changeState = true;
	}

}

void MenuState::update()
{
}

void MenuState::draw() const
{
	renderer->drawSprite(*resources->getTexture("HansTap.png"),
		glm::vec2(200, 200), glm::vec2(300, 400), 45.0f, glm::vec3(0.0f, 1.0f, 0.0f));
}

void MenuState::pause()
{
}

void MenuState::resume()
{
}
