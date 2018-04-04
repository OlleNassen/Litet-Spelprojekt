#pragma once
#include "state.hpp"
#include "../Renderer/spriteRenderer.hpp"

class GameState :public State
{
private:

public:
	GameState();
	~GameState();

	void handleInput() override;
	void update() override;
	void draw()const override;

	void pause() override;
	void resume() override;
};