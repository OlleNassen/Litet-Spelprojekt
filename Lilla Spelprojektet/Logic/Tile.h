#pragma once
#include"../Renderer/spriteRenderer.hpp"

enum TileTypes {DEFAULT = 0, COLLIDER};


class Tile
{
private:
	int type;
	

public:
	Tile();
	virtual ~Tile();
};

