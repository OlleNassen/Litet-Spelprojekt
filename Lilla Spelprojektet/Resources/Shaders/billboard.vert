#version 440

in vec2 aPos;
in vec2 texcoord;
in vec3 aColor;
in vec2 aOffset;

out vec3 fColor;
out vec2 vs_texcoord;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

void main()
{
    fColor = aColor;
	vs_texcoord = texcoord;
    gl_Position = projection * view * model * vec4(aPos + aOffset, 0.0, 1.0);
}