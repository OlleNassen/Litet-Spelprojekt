#include "game.hpp"

int main(int argc, char** argv)
{	
	Game game;
	game.run();
	return 0;
}

int WINAPI WinMain(HINSTANCE hThisInstance, HINSTANCE hPrevInstance, LPSTR lpszArgument, int nCmdShow)
{
	Game game;
	game.run();
	return 0;
}

