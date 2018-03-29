#version 440

layout (location = 0) in vec3 vertex_position;
layout (location = 1) in vec3 vertex_normal;
layout (location = 2) in vec2 vertex_texcoord;
layout (location = 3) in vec3 vertex_color;

out vec3 vs_position;
out vec3 vs_normal;
out vec2 vs_texcoord;
out vec3 vs_color;

void main()
{
	vs_position = vertex_position;
	vs_normal = vertex_normal;
	vs_texcoord = vec2(vertex_texcoord.x, vertex_texcoord.y * -1.f);

	gl_Position = vec4(vertex_position, 1.0f);
}
