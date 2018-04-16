#version 440
#define NUM_LIGHTS 5 //Hardcoded for now

layout (location = 0) in vec3 POSITION;
layout (location = 1) in vec3 NORMAL;
layout (location = 2) in vec2 TEXCOORD;
layout (location = 3) in vec3 TANGENT;
layout (location = 4) in vec3 BITANGENT;

out VS_OUT {
    vec3 FragPos;
    vec2 TexCoords;
    vec3 TangentLightPos[NUM_LIGHTS];
    vec3 TangentViewPos;
    vec3 TangentFragPos;
} vs_out;

uniform mat4 projection;
uniform mat4 view;
uniform mat4 model;

uniform vec3 lightPos[NUM_LIGHTS];
uniform vec3 viewPos;

void main()
{
    vs_out.FragPos = vec3(model * vec4(POSITION, 1.0));   
    vs_out.TexCoords = TEXCOORD;
    
    mat3 normalMatrix = transpose(inverse(mat3(model)));
    vec3 T = normalize(normalMatrix * TANGENT);
    vec3 N = normalize(normalMatrix * NORMAL);
    T = normalize(T - dot(T, N) * N);
    vec3 B = cross(N, T);
    
    mat3 TBN = transpose(mat3(T, B, N));    
	for(int i = 0; i < NUM_LIGHTS; i++)
	{
		vs_out.TangentLightPos[i] = TBN * lightPos[i];
	}
    vs_out.TangentViewPos  = TBN * viewPos;
    vs_out.TangentFragPos  = TBN * vs_out.FragPos;
        
    gl_Position = projection * view * model * vec4(POSITION, 1.0);
}