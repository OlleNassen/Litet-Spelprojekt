#version 440

in vec2 vertex_position;
in vec2 vertex_texcoord;
in vec3 vertex_color;

out vec2 vs_position;
out vec2 vs_texcoord;
out vec3 vs_color;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

void main()
{
	vs_position = vertex_position;
	vs_texcoord = vec2(vertex_texcoord.x, vertex_texcoord.y);
	vs_color = vertex_color;

	gl_Position = projection * view * model * vec4(vertex_position.xy, 0, 1.0);
	//gl_Position = vec4(vertex_position.xy, 0, 1.0);

}
