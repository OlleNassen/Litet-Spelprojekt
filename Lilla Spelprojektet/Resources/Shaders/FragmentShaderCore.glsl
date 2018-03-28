#version 440

in vec3 vs_position;
in vec3 vs_normal;
in vec2 vs_texcoord;
in vec3 vs_color;

out vec4 fs_color;

void main()
{
	fs_color = vec4(vs_color, 1.f);
}
