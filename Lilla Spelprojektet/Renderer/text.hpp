#pragma once
#include <string>
#include <map>
#include "shader.hpp"
#include <glm\glm.hpp>
#include <ft2build.h>
#include FT_FREETYPE_H

struct Character {
	GLuint     TextureID;  // ID handle of the glyph texture
	glm::ivec2 Size;       // Size of glyph
	glm::ivec2 Bearing;    // Offset from baseline to left/top of glyph
	GLuint     Advance;    // Offset to advance to next glyph
};


class Text
{
private:
	FT_Library library;
	Shader* shader;
	GLuint VAO, VBO;
	std::map <GLchar, Character> Characters;

public:
	Text(Shader* shader);
	~Text();
	void RenderText(std::string text, GLfloat x, GLfloat y, GLfloat scale, glm::vec3 color, const glm::mat4& projection);
	void RenderHighscore(std::string text, GLfloat x, GLfloat y, GLfloat scale, glm::vec3 color, const glm::mat4& projection);

};