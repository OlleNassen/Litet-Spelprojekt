#version 440
layout (location = 0) in vec2 vs_position;
layout (location = 1) in vec3 vs_color;
layout (location = 2) in vec2 vs_offset;

out vec3 vertex_color;

void main()
{
    vertex_color = vs_color;
    gl_Position = vec4(vs_position + vs_offset, 0.0, 1.0);
}  