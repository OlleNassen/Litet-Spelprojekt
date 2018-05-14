#version 440
layout (location = 0) in vec2 aPos;
layout(location = 1) in vec2 texcoord;
layout (location = 2) in vec3 aColor;
layout (location = 3) in vec2 aOffset;

out vec3 fColor;
out vec2 vs_texcoord;

void main()
{
    fColor = aColor;
	vs_texcoord = texcoord;
    gl_Position = vec4(aPos + aOffset, 0.0, 1.0);
}