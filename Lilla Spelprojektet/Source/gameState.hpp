#pragma once
#include "state.hpp"

class GameState :public State
{
private:
public:
	void handleEvents() override;
	void handleInput() override;
	void update() override;
	void draw()const override;

	void pause() override;
	void resume() override;
};