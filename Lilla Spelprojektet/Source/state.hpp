#pragma once

//Prototyp

//Abstrakt klass

class State
{
protected:
	bool changeState;

public:
	State() :changeState(false) {}
	virtual ~State() {}

	virtual void handleEvents() = 0;
	virtual void handleInput() = 0;
	virtual void update() = 0;
	virtual void draw()const = 0;

	virtual void pause() = 0;
	virtual void resume() = 0;

	bool changeState()const
	{
		return changeState;
	}
};