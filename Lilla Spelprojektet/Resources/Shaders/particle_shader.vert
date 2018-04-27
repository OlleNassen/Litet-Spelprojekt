#version 440
layout (location = 0) in vec2 vertex_position;
layout (location = 1) in vec2 vertex_texcoord;
layout (location = 2) in vec3 vertex_color;
layout (location = 3) in vec2 vertex_offset;

out vec2 vs_texcoord;
out vec3 vs_color;

void main()
{
	vs_texcoord = vertex_texcoord;
    vs_color = vertex_color;

    gl_Position = vec4(vertex_position + vertex_offset, 0.0, 1.0);
}  