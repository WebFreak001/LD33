#version 330
uniform sampler2D tex;
uniform sampler2D nrm;
uniform vec3 ldir;
in vec2 texCoord;
layout(location = 0) out vec4 out_frag_color;

void main()
{
	vec3 normal = normalize(texture(nrm, texCoord).xyz * 2 - 1);
	float intensity = dot(normal, normalize(ldir));
	vec3 rgb = texture(tex, texCoord).rgb * max(0.1, intensity);
	out_frag_color = vec4(rgb, texture(tex, texCoord).a);
}
