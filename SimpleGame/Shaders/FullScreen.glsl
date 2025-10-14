#version 330

layout(location=0) out vec4 FragColor;

uniform vec4 u_Color;

void main()
{
	vec4 newColor = u_Color;

//	newColor = vec4(1,1,1, newColor.a);

	FragColor = vec4(u_Color);
}
