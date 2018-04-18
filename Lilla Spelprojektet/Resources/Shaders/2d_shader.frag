#version 440

//attributes from vertex shader
in vec2 vs_position;
in vec2 vs_texcoord;

out vec4 fragColor;

//our texture samplers
uniform sampler2D diffuseMap;   //diffuse map
uniform sampler2D normalMap;   //normal map

//values used for shading algorithm...
uniform vec3 lightPos;        //light position, normalized
uniform vec4 lightColor;      //light RGBA -- alpha is intensity

void main()
{
	float normalMapIntensity = 150.0;
	float radius = 1000.0;
	vec4 ambientColor =  vec4(0.3, 0.3, 0.3, 0.3);

	//RGBA of our diffuse color
	vec4 diffuseColor = texture2D(diffuseMap, vs_texcoord);
	
	//RGB of our normal map
	vec3 normalColor = texture2D(normalMap, vs_texcoord).rgb;
	
	vec3 lightDir = vec3(vec3(lightPos.xy, normalMapIntensity) - vec3(vs_position, 0.0));
	
	//Determine distance (used for attenuation) BEFORE we normalize our LightDir
	float D = length(lightDir.xy);
	
	//normalize our vectors
	vec3 N = normalize(normalColor * 2.0 - 1.0);
	vec3 L = normalize(lightDir);

	vec3 ambient = ambientColor.rgb * ambientColor.a;
	
	//attenuation
	float fall = 1.0 - (D / radius);

	float diff = max(dot(N,L), 0.0);

	vec3 diffuse = diff * (lightColor.rgb + diffuseColor.rgb);
	
	//smoothstep(0.0, 1.0, fall)

	fragColor = vec4(((ambient + diffuse) * fall), diffuseColor.a);

}