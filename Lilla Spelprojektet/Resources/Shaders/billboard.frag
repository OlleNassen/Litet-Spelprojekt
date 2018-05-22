#version 440

in vec2 vs_position;
in vec2 vs_texcoord;
in vec3 vs_color;

out vec4 fragColor;

uniform sampler2D image;


void main()
{
   	fragColor = texture2D(image, vs_texcoord) * vec4(0.1,0.2,0.8, 0.5);
}

