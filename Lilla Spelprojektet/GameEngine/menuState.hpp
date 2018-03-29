#pragma once
#include "state.hpp"

class MenuState :public State
{
private:
	SpriteRenderer* renderer;
	Shader* shader;
public:
	MenuState();
	~MenuState();

	void handleInput() override;
	void update() override;
	void draw()const override;

	void pause() override;
	void resume() override;
};