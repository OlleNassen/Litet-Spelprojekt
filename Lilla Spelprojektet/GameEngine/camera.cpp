#include "camera.hpp"
#include <cmath>


Camera::Camera() :
	center(),
	size(),
	rotation(0),
	viewport(0, 0, 1, 1)
{
	reset(FloatRect(0, 0, 1280, 720));
}

void Camera::setCenter(float x, float y)
{
	center.x = x;
	center.y = y;
}

void Camera::setCenter(const sf::Vector2f& center)
{
	setCenter(center.x, center.y);
}


void Camera::setSize(float width, float height)
{
	size.x = width;
	size.y = height;
}

void Camera::setSize(const sf::Vector2f& size)
{
	setSize(size.x, size.y);
}

void Camera::setViewport(const FloatRect& viewport)
{
	this->viewport = viewport;
}


void Camera::reset(const FloatRect& rectangle)
{
	center.x = rectangle.left + rectangle.width / 2.f;
	center.y = rectangle.top + rectangle.height / 2.f;
	size.x = rectangle.width;
	size.y = rectangle.height;
	rotation = 0;
}


////////////////////////////////////////////////////////////
const sf::Vector2f& Camera::getCenter() const
{
	return center;
}


////////////////////////////////////////////////////////////
const sf::Vector2f& Camera::getSize() const
{
	return size;
}

////////////////////////////////////////////////////////////
const FloatRect& Camera::getViewport() const
{
	return viewport;
}


////////////////////////////////////////////////////////////
void Camera::move(float offsetX, float offsetY)
{
	setCenter(center.x + offsetX, center.y + offsetY);
}


////////////////////////////////////////////////////////////
void Camera::move(const sf::Vector2f& offset)
{
	setCenter(center + offset);
}


////////////////////////////////////////////////////////////
void Camera::zoom(float factor)
{
	setSize(size.x * factor, size.y * factor);
}

glm::mat4 Camera::getProjection()
{
	float x = center.x - size.x / 2;
	float y = center.y - size.y / 2;
	
	return glm::ortho(x, size.x, size.y, y, -1.0f, 1.0f);;
}