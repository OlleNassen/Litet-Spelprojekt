#version 440
out vec4 FragColor;

in vec2 vs_texcoord;
in vec3 fColor;

uniform sampler2D image;


void main()
{
   	FragColor = texture(image, vs_texcoord) * vec4(0.3,0.5,0.8, 1);
}

