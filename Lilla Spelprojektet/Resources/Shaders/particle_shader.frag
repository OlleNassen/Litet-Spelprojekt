#version 440
out vec4 fragColor;
  
in vec3 vertex_color;

void main()
{
    fragColor = vec4(vertex_color, 1.0);
}