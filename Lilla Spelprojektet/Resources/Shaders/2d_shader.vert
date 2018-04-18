#version 440

in vec2 vertex_position;
in vec2 vertex_texcoord;

out vec2 vs_position;
out vec2 vs_texcoord;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

void main()
{
	// vs_position = vertex_position;
	vs_position =  vec2(model * vec4(vertex_position.xy, 0, 1.0));
	vs_texcoord = vertex_texcoord;

	gl_Position = projection * view * model * vec4(vertex_position.xy, 0, 1.0);
}
