#pragma once
#include "../libs.h"

//Prototyp

//Abstrakt klass

class State
{
protected:
	bool changeState;
	bool running;

public:
	State() :changeState(false), running(true) {}
	virtual ~State() {}

	virtual void handleInput() = 0;
	virtual void update() = 0;
	virtual void draw()const = 0;

	virtual void pause() = 0;
	virtual void resume() = 0;
	
	bool getChangeState()const
	{
		return changeState;
	}
	

	bool isRunning()const
	{
		return running;
	}
};
