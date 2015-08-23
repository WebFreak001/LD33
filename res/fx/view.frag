#version 330
uniform sampler2D tex;
in vec2 texCoord;
layout(location = 0) out vec4 out_frag_color;

void main()
{
	out_frag_color = vec4(1, 1, 1, (1.0f - texCoord.x * texCoord.x * texCoord.x * texCoord.x) * 0.2f);
}
