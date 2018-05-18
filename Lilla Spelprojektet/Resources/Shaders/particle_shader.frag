#version 440

#define NUM_LIGHTS 10 + 1 //1 is pixie
 
in vec2 vs_position;
in vec2 vs_texcoord;
in vec3 vs_color;

out vec4 fragColor;

uniform sampler2D diffuseMap;   //diffuse map


void main()
{

	//RGBA of our diffuse color
	vec4 diffuseColor = texture2D(diffuseMap, vs_texcoord);

	fragColor = vec4(diffuseColor.rgb, diffuseColor.a);

}