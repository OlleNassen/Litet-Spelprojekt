#version 440
out vec4 fragColor;
  
in vec2 vs_texcoord;
in vec3 vs_color;

uniform sampler2D diffuseMap;   //diffuse map
uniform sampler2D normalMap;   //normal map

void main()
{
    fragColor = texture(diffuseMap, vs_texcoord);
}