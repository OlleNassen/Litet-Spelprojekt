#version 440
layout (location = 0) in vec2 vertex_position;
layout (location = 1) in vec2 vertex_texcoord;
layout (location = 2) in vec3 vertex_color;
layout (location = 3) in vec2 vertex_offset;

out vec2 vs_position;
out vec2 vs_texcoord;
out vec3 vs_color;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

void main()
{
	vs_position =  vec2(model * vec4(vertex_position.xy, 0, 1.0));
	vs_texcoord = vertex_texcoord;
    vs_color = vertex_color;

    gl_Position = projection * view * model * vec4(vertex_position.xy + vertex_offset, 0.0, 1.0);
}  