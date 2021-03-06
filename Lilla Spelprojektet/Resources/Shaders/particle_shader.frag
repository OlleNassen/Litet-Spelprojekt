#version 440

#define NUM_LIGHTS 10 + 1 //1 is pixie
 
in vec2 vs_position;
in vec2 vs_texcoord;
in vec3 vs_color;

out vec4 fragColor;

uniform sampler2D diffuseMap;   //diffuse map

vec2 random2(vec2 st)
{
    st = vec2( dot(st,vec2(127.1,311.7)),
              dot(st,vec2(269.5,183.3)) );
    return -1.0 + 2.0*fract(sin(st)*43758.5453123);
}

float random (vec2 st)
{
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

void main()
{
	vec2 st = gl_FragCoord.xy/vec2(1280,720);

	st *= 5.0;

	vec2 ipos = floor(st);
	vec2 fpos = fract(st);

	vec3 c = vec3(random(ipos));

	//RGBA of our diffuse color
	vec4 diffuseColor = texture2D(diffuseMap, vs_texcoord);

	//fragColor = vec4(diffuseColor.rgb, diffuseColor.a);// * vec4(random(gl_FragCoord.xy), random(gl_FragCoord.xy), random(gl_FragCoord.xy), 1);

	fragColor = vec4(0.3, random2(st).x, 0.3, 1);

}