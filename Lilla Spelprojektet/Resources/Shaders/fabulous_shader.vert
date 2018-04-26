#version 440
layout (location = 0) in vec2 vs_position;
layout (location = 1) in vec3 vs_color;

out vec3 color;

uniform vec2 offsets[100];

void main()
{
    vec2 offset = offsets[gl_InstanceID];
    gl_Position = vec4(vs_position + offset, 0.0, 1.0);
    color = vs_color;
}  