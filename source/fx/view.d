module fx.view;

import d2d;

import std.file;

class ViewIndicatorShader : ShaderProgram
{
	this()
	{
		super();
		Shader vertex = new Shader();
		vertex.load(ShaderType.Vertex, "#version 330
layout(location = 0) in vec3 in_position;
layout(location = 1) in vec2 in_tex;
uniform mat4 transform;
uniform mat4 projection;
out vec2 texCoord;
void main()
{
	gl_Position = projection * transform * vec4(in_position, 1);
	texCoord = in_tex;
}
");
		Shader fragment = new Shader();
		fragment.load(ShaderType.Fragment, readText("res/fx/view.frag"));
		attach(vertex);
		attach(fragment);
		link();
		bind();
		registerUniform("tex");
		registerUniform("transform");
		registerUniform("projection");
		set("tex", 0);
	}
}
