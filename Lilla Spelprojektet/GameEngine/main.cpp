#include "game.hpp"
#include <windows.h>  
#include <stdlib.h>  
#include <string.h>  
#include <tchar.h> 

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

