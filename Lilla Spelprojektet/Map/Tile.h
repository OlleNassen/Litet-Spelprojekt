#pragma once

enum TileTypes {DEFAULT = 0, COLLIDER};

class Tile
{
private:
	int type;
	

public:
	Tile();
	virtual ~Tile();
};

