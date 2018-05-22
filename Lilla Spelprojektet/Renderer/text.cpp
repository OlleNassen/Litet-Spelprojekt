#include "text.hpp"
#include <gl/glew.h>
#include <iostream>

Text::Text()
{
	FT_Error error = FT_Init_FreeType(&library);
	if (error)
	{
		std::cout << "error occurred during library initialization ...";
	}
}

Text::~Text()
{
}
