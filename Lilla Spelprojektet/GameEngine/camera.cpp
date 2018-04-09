#include "camera.hpp"
#include <cmath>


Camera::Camera(int width, int height) :
	center(),
	size(),
	rotation(0),
	viewport(0, 0, 1, 1),
	scaleFactor(2)
{
	reset(FloatRect(0, 0, width, height));

	front = glm::vec3(0.f, 0.f, -1.f);
	up = glm::vec3(0.f, 1.f, 0.f);
}

Camera::~Camera()
{
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

void Camera::setPosition(const sf::Vector2f & setPosition)
{
	setCenter(setPosition.x, setPosition.y);
}


////////////////////////////////////////////////////////////
void Camera::zoom(float factor)
{
	scaleFactor = factor;
}

glm::mat4 Camera::getProjection()
{
	return glm::ortho(0.f, size.x/scaleFactor, size.y / scaleFactor, 0.f, -1.0f, 1.0f);
}

glm::mat4 Camera::getView()
{
	float x = center.x - size.x / (scaleFactor * 2);
	float y = center.y - size.y / (scaleFactor * 2);
	
	glm::vec3 position(x, y, 0.f);

	return glm::lookAt(position, position + front, up);
}
