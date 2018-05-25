#version 440
in  vec2  TexCoords;
out vec4  color;
  
uniform sampler2D scene;
uniform vec2      offsets[9];
uniform float     blur_kernel[9];

uniform bool lowHealth;
uniform bool confuse;
uniform bool shake;
uniform bool flash;
uniform vec2 curtain;

void main()
{
    color = vec4(0.0f);
    vec3 sam[9];
    
	// sample from texture offsets if using convolution matrix
    if(shake)
	{
        for(int i = 0; i < 9; i++)
		 {
			sam[i] = vec3(texture(scene, TexCoords.st + offsets[i]));
		 }
    }      
    
	
	// process effects
    if(confuse)
    {
        color = vec4(1.0 - texture(scene, TexCoords).rgb, 1.0);
    }
    else if(shake)
    {
        for(int i = 0; i < 9; i++)
		{			
			color += vec4(sam[i] * blur_kernel[i], 0.0f);
		}           
        color.a = 1.0f;
    }
    else
    {
        color =  texture(scene, TexCoords);	
    }

	if(flash)
	{
		color += vec4(0.8, 0.0, 0.0, 0.0);
	}

	if(lowHealth)
    {           
        color = texture(scene, TexCoords);
		float average = (color.r + color.g + color.b) / 3.0;
		color = vec4(average, average, average, 1.0);
    }

	if(TexCoords.x > curtain.x && TexCoords.y > curtain.y)
	{
		color = vec4(0.0, 0.0, 0.0, 1.0);
	}
}