#include "spriteRenderer.hpp"
#define BUFFER_OFFSET(i) ((char *)nullptr + (i))

static unsigned int a[] =
{
	1,1,1,1,1,1,1,1,1,1,
	1,0,0,0,0,0,0,0,0,1,
	1,0,0,0,0,0,0,0,0,1,
	1,0,0,0,0,0,0,0,0,1,
	1,0,0,0,0,0,0,0,0,1,
	1,0,0,0,0,0,0,0,0,1,
	1,0,0,0,0,0,0,0,0,1,
	1,0,0,0,0,0,0,0,0,1,
	1,0,0,0,0,0,0,0,0,1,
	1,1,1,1,1,1,1,1,1,1
};

SpriteRenderer::SpriteRenderer(Shader *shader, std::vector<lua_State*>* luaStateVector)
{
	tileMap = a;
	addVector(luaStateVector);
	this->shader = shader;
	initRenderData();
	for(int i = 0; i < 100; i++)
		initTiles();
}

SpriteRenderer::~SpriteRenderer()
{
	//Do not delete shader, it will be deleted by ResourceManager
}

void SpriteRenderer::initRenderData()
{
	// Configure VAO/VBO
	GLuint VBO;
	//Fix this ugly mess
	float vertices[] = {
		// Pos              //Normal     // Tex      // COlor
		0.0f, 1.0f, 0.0f, 1.0f, 0.0f, 1.0f, 0.0f, 1.0f, 0.0f,
		1.0f, 0.0, 0.0f, 1.0f, 1.0f, 0.0f, 0.0f, 1.0f, 0.0f,
		0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f,

		0.0f, 1.0f, 0.0f, 1.0f, 0.0f, 1.0f, 0.0f, 1.0f, 0.0f,
		1.0f, 1.0f, 0.0f, 1.0f, 1.0f, 1.0f, 0.0f, 1.0f, 0.0f,
		1.0f, 0.0f, 0.0f, 1.0f, 1.0f, 0.0f, 0.0f, 1.0f, 0.0f
	};

	glGenVertexArrays(1, &this->quadVAO);
	glBindVertexArray(this->quadVAO);

	glGenBuffers(1, &VBO);
	glBindBuffer(GL_ARRAY_BUFFER, VBO);
	glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);


	// Buffer offset. 
	int offset = 0;

	//Position
	glEnableVertexAttribArray(0);
	glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 9 * sizeof(float), BUFFER_OFFSET(offset));
	offset += sizeof(float) * 2;
	//Normal
	glEnableVertexAttribArray(1);
	glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 9 * sizeof(float), BUFFER_OFFSET(offset));
	offset += sizeof(float) * 2;
	//Texture coordinates
	glEnableVertexAttribArray(2);
	glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, 9 * sizeof(float), BUFFER_OFFSET(offset));
	offset += sizeof(float) * 2;
	//Color
	glEnableVertexAttribArray(3);
	glVertexAttribPointer(3, 3, GL_FLOAT, GL_FALSE, 9 * sizeof(float), BUFFER_OFFSET(offset));
	offset += sizeof(float) * 3;
}

void SpriteRenderer::initTiles()
{
	GLuint VAO;
	// Configure VAO/VBO
	GLuint VBO;
	//Fix this ugly mess
	float vertices[] = {
		// Pos              //Normal     // Tex      // COlor
		0.0f, 1.0f, 0.0f, 1.0f, 0.0f, 1.0f, 0.0f, 1.0f, 0.0f,
		1.0f, 0.0, 0.0f, 1.0f, 1.0f, 0.0f, 0.0f, 1.0f, 0.0f,
		0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f,

		0.0f, 1.0f, 0.0f, 1.0f, 0.0f, 1.0f, 0.0f, 1.0f, 0.0f,
		1.0f, 1.0f, 0.0f, 1.0f, 1.0f, 1.0f, 0.0f, 1.0f, 0.0f,
		1.0f, 0.0f, 0.0f, 1.0f, 1.0f, 0.0f, 0.0f, 1.0f, 0.0f
	};

	glGenVertexArrays(1, &VAO);
	glBindVertexArray(VAO);

	glGenBuffers(1, &VBO);
	glBindBuffer(GL_ARRAY_BUFFER, VBO);
	glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);


	// Buffer offset. 
	int offset = 0;

	//Position
	glEnableVertexAttribArray(0);
	glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 9 * sizeof(float), BUFFER_OFFSET(offset));
	offset += sizeof(float) * 2;
	//Normal
	glEnableVertexAttribArray(1);
	glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 9 * sizeof(float), BUFFER_OFFSET(offset));
	offset += sizeof(float) * 2;
	//Texture coordinates
	glEnableVertexAttribArray(2);
	glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, 9 * sizeof(float), BUFFER_OFFSET(offset));
	offset += sizeof(float) * 2;
	//Color
	glEnableVertexAttribArray(3);
	glVertexAttribPointer(3, 3, GL_FLOAT, GL_FALSE, 9 * sizeof(float), BUFFER_OFFSET(offset));
	offset += sizeof(float) * 3;

	tileVAO.push_back(VAO);
}


void SpriteRenderer::drawSprite(Texture2D &texture,
	glm::vec2 size, GLfloat rotate, glm::vec3 color)
{
	glm::vec2 position;
	lua_getglobal(luaVector->back(), "getPosition");
	if (lua_isfunction(luaVector->back(), -1))
	{
		lua_pcall(luaVector->back(), 0, 2, 0);
		position.x = lua_tonumber(luaVector->back(), -1);
		position.y = lua_tonumber(luaVector->back(), -2);
		lua_pop(luaVector->back(), 2);
	}
	else std::cout << "getPosition is not a function" << std::endl;

	// Prepare transformations
	glm::mat4 model = glm::mat4(1.f);
	model = glm::translate(model, glm::vec3(position, 0.0f));

	model = glm::translate(model, glm::vec3(0.5f * size.x, 0.5f * size.y, 0.0f));
	model = glm::rotate(model, rotate, glm::vec3(0.0f, 0.0f, 1.0f));
	model = glm::translate(model, glm::vec3(-0.5f * size.x, -0.5f * size.y, 0.0f));

	model = glm::scale(model, glm::vec3(size, 1.0f));

	this->shader->setMatrix4fv(model,"model");
	this->shader->use();
	texture.bind();

	glBindVertexArray(this->quadVAO);
	glDrawArrays(GL_TRIANGLES, 0, 6);
	glBindVertexArray(0);
}

void SpriteRenderer::drawTiles(Texture2D &texture,
	glm::vec2 size, GLfloat rotate, glm::vec3 color)
{
	int i = 0;
	
	for (auto& tile : tileVAO)
	{
		float x = (i % 10) * 48;
		float y = (i / 10) * 48;
		
		glm::vec2 position(x,y);


		// Prepare transformations
		glm::mat4 model = glm::mat4(1.f);
		model = glm::translate(model, glm::vec3(position, 0.0f));

		model = glm::translate(model, glm::vec3(0.5f * size.x, 0.5f * size.y, 0.0f));
		model = glm::rotate(model, rotate, glm::vec3(0.0f, 0.0f, 1.0f));
		model = glm::translate(model, glm::vec3(-0.5f * size.x, -0.5f * size.y, 0.0f));

		model = glm::scale(model, glm::vec3(size, 1.0f));

		this->shader->setMatrix4fv(model, "model");
		this->shader->use();
		texture.bind();

		glBindVertexArray(tile);
		if(tileMap[i] != 0)
			glDrawArrays(GL_TRIANGLES, 0, 6);
		glBindVertexArray(0);

		i++;
	}


}

void SpriteRenderer::addVector(std::vector<lua_State*>* vector)
{
	luaVector = vector;
}
