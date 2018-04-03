#version 440

in vec2 vs_position;
in vec2 vs_normal;
in vec2 vs_texcoord;
in vec3 vs_color;

out vec4 fs_color;
uniform sampler2D image;

void main()
{
	fs_color = vec4(0.f, 1.f, 0.f, 1.0) * texture(image, vs_texcoord);
	//gl_FragColor = vec4(0.f, 1.f, 0.f, 1.0);
}
