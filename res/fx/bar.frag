#version 330
uniform sampler2D tex;
uniform float progress;
in vec2 texCoord;
layout(location = 0) out vec4 out_frag_color;

void main()
{
	if(texCoord.x > progress)
		out_frag_color = vec4(vec3(dot(texture(tex, texCoord).rgb, vec3(0.299, 0.587, 0.114))), texture(tex, texCoord).a);
	else
		out_frag_color = texture(tex, texCoord);
}
