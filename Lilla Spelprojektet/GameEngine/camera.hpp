#ifndef CAMERA_HPP
#define CAMERA_HPP

#include <glm/glm.hpp>
#include <SFML/System/Vector2.hpp>
#include "../libs.h"

struct FloatRect
{
	FloatRect(float left, float top, float width, float height)
	{
		this->left = left;
		this->top = top;
		this->width = width;
		this->height = height;
	}
	
	float left;
	float top;
	float width;
	float height;
};


class Camera
{
public:

	Camera(int width, int height);

	void setCenter(float x, float y);	
	void setCenter(const sf::Vector2f& center);
	void setSize(float width, float height);
	void setSize(const sf::Vector2f& size);
	void setViewport(const FloatRect& Cameraport);
	void reset(const FloatRect& rectangle);
	const sf::Vector2f& getCenter() const;
	const sf::Vector2f& getSize() const;
	const FloatRect& getViewport() const;
	void move(float offsetX, float offsetY);
	void move(const sf::Vector2f& offset);
	void setPosition(const sf::Vector2f& setPosition);
	void zoom(float factor);
	glm::mat4 getProjection();
	glm::mat4 getView();

private:
	sf::Vector2f center;              ///< Center of the Camera, in scene coordinates
	sf::Vector2f size;                ///< Size of the Camera, in scene coordinates
	float rotation;            ///< Angle of rotation of the Camera rectangle, in degrees
	FloatRect viewport;           
	//glm::vec3 position;
	//glm::vec3 front;
	//glm::vec3 up;

};


#endif // CAMERA_HPP