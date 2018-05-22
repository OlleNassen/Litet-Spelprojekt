#pragma once
#include <string>
#include <ft2build.h>
#include FT_FREETYPE_H 

class Text
{
private:
	FT_Library library;
public:
	Text();
	~Text();
};