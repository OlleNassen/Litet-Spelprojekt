#pragma once
#include <../stb/stb_truetype.h>
#include <string>
#define STB_TRUETYPE_IMPLEMENTATION

class Text
{
private:

public:
	Text(const std::string& text);
	~Text();
};