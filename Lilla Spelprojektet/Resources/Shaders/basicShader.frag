#version 440

in vec2 vs_position;
in vec2 vs_texcoord;

out vec4 fs_color;
uniform sampler2D image;

void main()
{
	fs_color = texture(image, vs_texcoord);
}
