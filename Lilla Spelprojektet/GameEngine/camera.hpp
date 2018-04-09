#ifndef CAMERA_HPP
#define CAMERA_HPP

#include <glm/glm.hpp>
#include <SFML/System/Vector2.hpp>

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

	Camera();

	explicit Camera(const FloatRect& rectangle);
	Camera(const sf::Vector2f& center, const sf::Vector2f& size);

	void setCenter(float x, float y);	
	void setCenter(const sf::Vector2f& center);
	void setSize(float width, float height);
	void setSize(const sf::Vector2f& size);
	void setRotation(float angle);
	void setViewport(const FloatRect& Cameraport);
	void reset(const FloatRect& rectangle);
	const sf::Vector2f& getCenter() const;
	const sf::Vector2f& getSize() const;
	float getRotation() const;
	const FloatRect& getViewport() const;
	void move(float offsetX, float offsetY);
	void move(const sf::Vector2f& offset);
	void rotate(float angle);
	void zoom(float factor);
	const glm::mat3& getTransform() const;
	const glm::mat3& getInverseTransform() const;

private:
	sf::Vector2f center;              ///< Center of the Camera, in scene coordinates
	sf::Vector2f size;                ///< Size of the Camera, in scene coordinates
	float rotation;            ///< Angle of rotation of the Camera rectangle, in degrees
	FloatRect viewport;            ///< Cameraport rectangle, expressed as a factor of the render-target's size
	mutable glm::mat3 transform;           ///< Precomputed projection glm::mat3 corresponding to the Camera
	mutable glm::mat3 inverseTransform;    ///< Precomputed inverse projection glm::mat3 corresponding to the Camera
	mutable bool transformUpdated;    ///< Internal state telling if the glm::mat3 needs to be updated
	mutable bool invTransformUpdated; ///< Internal state telling if the inverse glm::mat3 needs to be updated
};


#endif // CAMERA_HPP