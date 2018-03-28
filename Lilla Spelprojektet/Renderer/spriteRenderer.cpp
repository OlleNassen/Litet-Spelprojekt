#include "spriteRenderer.hpp"

SpriteRenderer::SpriteRenderer(Shader &shader)
{
	this->shader = &shader;
}

SpriteRenderer::~SpriteRenderer()
{
}

void SpriteRenderer::DrawSprite(glm::vec2 position, glm::vec2 size, GLfloat rotate, glm::vec3 color)
{
}

void SpriteRenderer::initRenderData()
{
}
