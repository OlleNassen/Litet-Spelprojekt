#include "camera.hpp"
#include <cmath>

Camera::Camera() :
	center(),
	size(),
	rotation(0),
	viewport(0, 0, 1, 1),
	transformUpdated(false),
	invTransformUpdated(false)
{
	reset(FloatRect(0, 0, 1000, 1000));
}

Camera::Camera(const FloatRect& rectangle) :
	center(),
	size(),
	rotation(0),
	viewport(0, 0, 1, 1),
	transformUpdated(false),
	invTransformUpdated(false)
{
	reset(rectangle);
}

Camera::Camera(const sf::Vector2f& center, const sf::Vector2f& size) :
	center(center),
	size(size),
	rotation(0),
	viewport(0, 0, 1, 1),
	transformUpdated(false),
	invTransformUpdated(false)
{

}

void Camera::setCenter(float x, float y)
{
	center.x = x;
	center.y = y;

	transformUpdated = false;
	invTransformUpdated = false;
}

void Camera::setCenter(const sf::Vector2f& center)
{
	setCenter(center.x, center.y);
}


void Camera::setSize(float width, float height)
{
	size.x = width;
	size.y = height;

	transformUpdated = false;
	invTransformUpdated = false;
}

void Camera::setSize(const sf::Vector2f& size)
{
	setSize(size.x, size.y);
}

void Camera::setRotation(float angle)
{
	rotation = static_cast<float>(fmod(angle, 360));
	if (rotation < 0)
		rotation += 360.f;

	transformUpdated = false;
	invTransformUpdated = false;
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

	transformUpdated = false;
	invTransformUpdated = false;
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
float Camera::getRotation() const
{
	return rotation;
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
void Camera::rotate(float angle)
{
	setRotation(rotation + angle);
}


////////////////////////////////////////////////////////////
void Camera::zoom(float factor)
{
	setSize(size.x * factor, size.y * factor);
}


////////////////////////////////////////////////////////////
const glm::mat3& Camera::getTransform() const
{
	// Recompute the matrix if needed
	if (!transformUpdated)
	{
		// Rotation components
		float angle = rotation * 3.141592654f / 180.f;
		float cosine = static_cast<float>(std::cos(angle));
		float sine = static_cast<float>(std::sin(angle));
		float tx = -center.x * cosine - center.y * sine + center.x;
		float ty = center.x * sine - center.y * cosine + center.y;

		// Projection components
		float a = 2.f / size.x;
		float b = -2.f / size.y;
		float c = -a * center.x;
		float d = -b * center.y;

		// Rebuild the projection matrix
		transform = glm::mat3(a * cosine, a * sine, a * tx + c,
			-b * sine, b * cosine, b * ty + d,
			0.f, 0.f, 1.f);
		transformUpdated = true;
	}

	return transform;
}


////////////////////////////////////////////////////////////
const glm::mat3& Camera::getInverseTransform() const
{
	// Recompute the matrix if needed
	if (!invTransformUpdated)
	{
		inverseTransform = glm::inverse(getTransform());
		invTransformUpdated = true;
	}

	return inverseTransform;
}

