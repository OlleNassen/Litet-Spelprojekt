#version 440

//attributes from vertex shader
in vec2 vs_position;
in vec2 vs_normal;
in vec2 vs_texcoord;
in vec3 vs_color;

out vec4 fragColor;

//our texture samplers
uniform sampler2D diffuseMap;   //diffuse map
uniform sampler2D normalMap;   //normal map

//values used for shading algorithm...
uniform vec3 LightPos;        //light position, normalized
uniform vec4 LightColor;      //light RGBA -- alpha is intensity
uniform vec4 AmbientColor;    //ambient RGBA -- alpha is intensity 

void main()
{
	float NormalMapIntensity = 100.0;
	float Radius = 1500.0;

	//RGBA of our diffuse color
	vec4 DiffuseColor = texture2D(diffuseMap, vs_texcoord);
	
	//RGB of our normal map
	vec3 NormalMap = texture2D(normalMap, vs_texcoord).rgb;
	
	//The delta position of light
	vec3 LightDir = vec3(vec3(LightPos.xy, NormalMapIntensity) - vec3(vs_position, 0.0));
	
	//Determine distance (used for attenuation) BEFORE we normalize our LightDir
	float D = length(LightDir.xy);
	
	//normalize our vectors
	vec3 N = normalize(NormalMap * 2.0 - 1.0);
	//N.g = N.g * -1;
	vec3 L = normalize(LightDir);
	
	//Pre-multiply light color with intensity
	//Then perform "N dot L" to determine our diffuse term
	//vec3 Diffuse = (LightColor.rgb * LightColor.a) * max(dot(N, L), 0.0);

	//pre-multiply ambient color with intensity
	vec3 Ambient = AmbientColor.rgb * AmbientColor.a;
	
	float fall = 1.0 - (D / Radius);

	float diff = max(dot(N,L), 0.0);

	vec3 diffuse = diff * DiffuseColor.rgb;
	
	//smoothstep(0.0, 1.0, fall)

	fragColor = vec4((Ambient + diffuse) * fall, 1.0f);

}