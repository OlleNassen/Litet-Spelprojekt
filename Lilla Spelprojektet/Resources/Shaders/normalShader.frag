#version 440
#define NUM_LIGHTS 5 //Hardcoded for now

out vec4 FragColor;

in VS_OUT {
    vec3 FragPos;
    vec2 TexCoords;
    vec3 TangentLightPos[NUM_LIGHTS];
    vec3 TangentViewPos;
    vec3 TangentFragPos;
} fs_in;

uniform vec3 lightPos[NUM_LIGHTS];
uniform vec3 viewPos;

uniform sampler2D diffuseMap;
uniform sampler2D normalMap;

void main()
{           
     // obtain normal from normal map in range [0,1]
    vec3 normal = texture(normalMap, fs_in.TexCoords).rgb;
    // transform normal vector to range [-1,1]
    normal = normalize(normal * 2.0 - 1.0);  // this normal is in tangent space
   
    // get diffuse color
    vec3 color = vec3(0.5, 0.9, 0.5) *texture(diffuseMap, fs_in.TexCoords).rgb;

	vec3 final_color = color;

    // ambient
    vec3 ambient = 0.1 * color;

	for(int i = 0; i < NUM_LIGHTS; i++)
	{
    // diffuse
    vec3 lightDir = normalize(fs_in.TangentLightPos[i] - fs_in.TangentFragPos);
    float diff = max(dot(lightDir, normal), 0.0);
    vec3 diffuse = diff * color;
    // specular
    vec3 viewDir = normalize(fs_in.TangentViewPos - fs_in.TangentFragPos);
    vec3 reflectDir = reflect(-lightDir, normal);
    vec3 halfwayDir = normalize(lightDir + viewDir);  
    float spec = pow(max(dot(normal, halfwayDir), 0.0), 32.0);

    vec3 specular = vec3(0.2) * spec;
	
	final_color += vec3(ambient + diffuse + specular);

	}

    FragColor = vec4(final_color, 1);
}

